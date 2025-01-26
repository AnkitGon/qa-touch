<template>
    <div v-if="isVisible" class="fixed inset-0 bg-gray-800 bg-opacity-50 z-50">
        <div class="bg-white p-6 rounded-lg w-1/3 mx-auto">
            <h2 class="text-xl font-bold mb-4">Add Test Case</h2>
            <form @submit.prevent="saveTestCase">
                <div class="mb-4">
                    <label for="module_id" class="block font-medium">Select Module</label>
                    <select v-model="form.module_id" id="module_id" class="w-full border p-2 rounded" required>
                        <option value="" disabled>Select a Module</option>
                        <option v-for="mod in modules" :key="mod.id" :value="mod.id">{{ mod.name }}</option>
                    </select>
                </div>
                <div class="mb-4">
                    <label for="summary" class="block font-medium">Test Case Summary</label>
                    <textarea v-model="form.summary" id="summary" class="w-full border p-2 rounded" rows="3"
                        required></textarea>
                </div>
                <div class="mb-4">
                    <label for="description" class="block font-medium">Description</label>
                    <textarea v-model="form.description" id="description" class="w-full border p-2 rounded"
                        rows="4"></textarea>
                </div>
                <div class="mb-4">
                    <label for="attachment" class="block font-medium">Attachment</label>
                    <input type="file" @change="handleFileUpload" class="w-full border p-2 rounded" accept="image/*"/>
                </div>
                <div class="flex justify-end">
                    <button type="button" @click="closeModal"
                        class="bg-gray-500 text-white px-4 py-2 rounded mr-2">Cancel</button>
                    <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">Save</button>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import { defaultsDeep } from 'lodash';
import toastr from 'toastr';

export default {
    'name': 'AddTestCaseModal',
    props: {
        isVisible: Boolean,
        selectedModuleId: {
            type: Number,
            required: true,
        },
        testCase: Object,
        selectedTestCase: Object,
        editing: Boolean
    },
    data() {
        return {
            form: {
                module_id: this.selectedTestCase ? this.selectedTestCase.module_id : '',
                summary: this.selectedTestCase ? this.selectedTestCase.summary : '',
                description: this.selectedTestCase ? this.selectedTestCase.description : '',
                attachment: null,
            },
            modules: [],
        };
    },
    mounted() {
        if (this.selectedModuleId && !this.selectedTestCase) {
            this.fetchModules(this.selectedModuleId); 
        }
    },
    watch: {
        selectedTestCase: {
            handler(newTestCase) {
                if (newTestCase) {
                    this.form = {
                        module_id: newTestCase.module_id,
                        summary: newTestCase.summary,
                        description: newTestCase.description,
                        attachment: null 
                    };
                    this.fetchModules(newTestCase.module_id);
                }
            },
            immediate: true,
        },
        selectedModuleId(newId) {
            if (newId && !this.selectedTestCase) {
                this.fetchModules(newId); 
            }
        },
    },
    methods: {
        async fetchModules(selectedModuleId) {
            let loader = this.$loading.show();

            try {
                const response = await axios.get('/test-cases'); 
                this.modules = response.data.data; 

                const selectedModule = response.data.data.find(module => module.id === selectedModuleId);

                this.modules = response.data.data;

            } catch (error) {
                toastr.error('Error fetching modules.','Error');
                
            }
            loader.hide();

        },
        handleFileUpload(event) {
            this.form.attachment = event.target.files[0];
        },
        saveTestCase() {
            if (!this.form.module_id || !this.form.summary.trim()) {
                toastr.error('Module and Summary are mandatory fields!.');
                return;
            }
            if (this.editing) {
                this.$emit('testCase', this.selectedTestCase.id,this.form);
            } else {
                this.$emit('save', this.form);
            }
            
            this.closeModal();
        },
        closeModal() {
            this.$emit('close');
            this.form = {
                module_id: '',
                summary: '',
                description: '',
                attachment: null 
            };
        },
    },
};
</script>
