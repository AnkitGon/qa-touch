<template>
    <div>
        <NavbarComponent />
        <div class="min-h-screen bg-gray-100 flex">
            <Sidebar @moduleSelected="handleModuleSelection" />
            <div class="flex-1 p-6">
                
                <div v-if="selectedModule">
                    <MainPanel :selectedModule="selectedModule" :testCases="testCases"
                        @openAddTestCaseModal="openAddTestCaseModal" @editTestCase="openEditTestCaseModal"
                        @deleteTestCase="deleteTestCase" />
                </div>
                <div v-else class="text-center text-gray-600">
                    <p>Select a module to view test cases.</p>
                </div>
            </div>
        </div>

        <AddTestCaseModal v-if="isModalVisible" :isVisible="isModalVisible" :editing="isEditingCase" :modules="modules" 
                @save="saveTestCase"
            :selectedModuleId="selectedModule.id" :selectedTestCase="selectedTestCase" @close="closeModal"
            @testCase="editTestCase" />

    </div>
</template>

<script>
import NavbarComponent from './partials/NavbarComponent';
import Sidebar from './partials/Sidebar';
import MainPanel from './partials/MainPanel';
import AddTestCaseModal from './TestCase/AddTestCaseModal';
import axios from 'axios';
import Swal from 'sweetalert2';
import toastr from 'toastr';

export default {
    name: 'DashboardComponent',
    components: {
        NavbarComponent,
        Sidebar,
        MainPanel,
        AddTestCaseModal,
    },
    data() {
        return {
            modules: [], 
            selectedModule: null,
            testCases: [],
            isModalVisible: false,
            selectedTestCase: null,
            selectedModuleId: null,
            isEditingCase: false
        };
    },
    methods: {
        handleModuleSelection(mod) {
                this.selectedModule = mod;
                this.fetchTestCases(mod.id);
        },
        async fetchTestCases(moduleId) {
            let loader = this.$loading.show();

            try {
                const response = await axios.get(`/test-cases/${moduleId}`);
                this.testCases = response.data;
            } catch (error) {
                toastr.error('Failed to fetch test cases:','Error');

            }
            loader.hide();

        },
        openAddTestCaseModal() {
            this.isModalVisible = true;
          
        },
        saveTestCase(testCase) {
            let loader = this.$loading.show();
            
            const formData = new FormData();
            formData.append('module_id', testCase.module_id);
            formData.append('summary', testCase.summary);
            formData.append('description', testCase.description);

            if (testCase.attachment) {
                formData.append('attachment', testCase.attachment);
            }

            axios.post('/test-cases', formData)
                .then(response => {
                    this.testCases.push(response.data);
                    this.isModalVisible = false;
                    this.isEditingCase = false;
                })
                .catch(error => {
                toastr.error('Error saving test case:','Error');

                });
            loader.hide();

        },
        closeModal() {
            this.isModalVisible = false;
            this.isEditingCase = false;
        },
        openEditTestCaseModal(testCase) {
           
            this.selectedTestCase = testCase; 
            this.selectedModuleId = testCase.module_id; 
            this.isModalVisible = true; 
            this.isEditingCase = true;
        },
        async editTestCase(id,testCase) { 
            let loader = this.$loading.show();
            
            const formData = new FormData();
            formData.append('module_id', testCase.module_id);
            formData.append('summary', testCase.summary);
            formData.append('description', testCase.description);

            if (testCase.attachment) {
                formData.append('attachment', testCase.attachment);
            }

            try {
                const response = await axios.post(`/test-cases/${id}`, formData);
                const updatedTestCase = response.data;
                
                const index = this.testCases.findIndex(tc => tc.id === updatedTestCase.id);
                if (index !== -1) {
                    this.testCases.splice(index, 1, updatedTestCase); 
                }

                this.closeModal(); 
            } catch (error) {
                toastr.error('Error editing test case:','Error');
            }
            loader.hide();

        },

        async deleteTestCase(testCaseId) {
            const result = await Swal.fire({
                title: 'Are you sure?',
                text: 'This action cannot be undone!',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Yes, delete it!',
                cancelButtonText: 'Cancel',
            });

            if (result.isConfirmed) {
                let loader = this.$loading.show();

                try {
                    await axios.delete(`/test-cases/${testCaseId}`);
                    this.testCases = this.testCases.filter(testCase => testCase.id !== testCaseId);
                    toastr.success('Test case deleted successfully!');
                } catch (error) {
                    toastr.error('Error deleting test case:', 'Error');
                }

                loader.hide();
            }
        }

    },
};
</script>

<style scoped>
.flex {
    display: flex;
}

.flex-1 {
    flex: 1;
}

.p-6 {
    padding: 1.5rem;
}
</style>
