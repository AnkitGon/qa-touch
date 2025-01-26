<template>
    <div class="bg-white w-96 border-r p-4">
        <h3 class="text-lg font-bold mb-4">Modules</h3>

        <div v-if="modules.length">
            <draggable :list="modules" group="parent-modules" @start="dragging = true" @end="dragging = false" 
                @change="onDragEnd" :move="onMoveParent" :animation="200" :itemKey="item => item.id"
                :handle="'.drag-handle'" tag="ul" class="child-list">
                <template #item="{ element }">
                    <li class="child-item">
                        <ModuleItem :module="element" :key="element.id" @add-child="openAddChildModal" @moduleSelected="selectModule"
                            @saveChildModuleOrder="saveNewModuleOrder" @edit="openEditModal" @delete="deleteModule" />
                    </li>
                </template>
            </draggable>


        </div>

        <p v-else>No modules found.</p>
        <button class="mt-4 px-4 py-2 bg-blue-500 text-white rounded" @click="openModuleModal">
            Add Module
        </button>

        <ModalComponent :isVisible="isModuleModalVisible" @close="closeModuleModal" @save="addModule" />

        <AddChildModalComponent :isVisible="isChildModalVisible" @close="closeChildModal" @save="saveChildModule" />
        <EditModuleModal v-if="isEditing" :isVisible="isEditing" :module="moduleToEdit" @close="isEditing = false"
            @save="saveModule" />
    </div>
</template>

<script>
import axios from 'axios';
import toastr from 'toastr';
import ModalComponent from '../pages/ModalComponent';
import AddChildModalComponent from '../pages/AddChildModalComponent';
import ModuleItem from '../pages/ModuleItem';
import EditModuleModal from '../pages/EditModuleModal';
import draggable from 'vuedraggable';
import Swal from 'sweetalert2';

export default {
    name: "Sidebar",
    components: {
        ModalComponent,
        AddChildModalComponent,
        ModuleItem,
        draggable,
        EditModuleModal,
    },
    data() {
        return {
            modules: [],
            isModuleModalVisible: false, // Parent Modal
            isChildModalVisible: false,  // Child Modal
            parentModule: null,
            newChildName: '',
            validationErrors: {},
            dragging: false,
            isEditing: false,
            moduleToEdit: null,
        };
    },
    mounted() {
        this.fetchModules();
    },
    methods: {
        async fetchModules() {
            let loader = this.$loading.show();
            try {
                const response = await axios.get('/modules');
                this.modules = response.data.data;
            } catch (error) {
                toastr.error('Error fetching modules.');
            }
            loader.hide();

        },
        toggleChildren(module) {
            module.isOpen = !module.isOpen;
        },
        openModuleModal() {
            this.isModuleModalVisible = true;
        },
        closeModuleModal() {
            this.isModuleModalVisible = false;
        },
        async addModule(newModule) {
            let loader = this.$loading.show();

            try {
                const response = await axios.post('/modules', newModule);
                toastr.success('Module added successfully!');
                this.modules.push(response.data);
                this.closeModuleModal();
                this.fetchModules();
            } catch (error) {
                toastr.error('Error adding module.');
            }
            loader.hide();

        },
        openAddChildModal(module) {
            this.parentModule = module;
            this.newChildName = '';
            this.isChildModalVisible = true; 
        },
        closeChildModal() {
            this.isChildModalVisible = false;
            this.validationErrors = {};
        },
        async saveChildModule(childName) {
            let loader = this.$loading.show();

            const trimmedName = childName.trim();
            if (!trimmedName) {
                this.validationErrors.name = 'Child module name is required.';
                return;
            }

            const newChildModule = {
                name: trimmedName,
                parent_id: this.parentModule.id,
            };

            try {
                const response = await axios.post('/modules', newChildModule);
                if (!this.parentModule.children) {
                    this.$set(this.parentModule, 'children', []);
                }
                this.parentModule.children.push(response.data); 
                this.parentModule.isOpen = true;

                toastr.success('Child module added successfully!');
                this.fetchModules();

                this.closeChildModal();
            } catch (error) {
                if (error.response && error.response.data.errors) {
                    this.validationErrors = error.response.data.errors;
                } else {
                    toastr.error('Error saving the child module.');
                }
            }
            loader.hide();
        },
        onDragEnd(evt) {
            this.saveNewModuleOrder(); 
        },
        onMoveParent(evt) {
            const draggedModule = evt.draggedContext.element;
            const targetModule = evt.relatedContext.element;

            if (!draggedModule.parent_id && !targetModule.parent_id) {
                return true;  
            }

            if (draggedModule.parent_id && targetModule.parent_id === null) {
                draggedModule.parent_id = targetModule.id; 
                return true;
            }

            return false;
        },
        async saveNewModuleOrder(eventData = null) {
            let loader = this.$loading.show();

            try {
                let updatedModules;

                if (eventData) { //childs
                    const { modules } = eventData;

                    updatedModules = modules.map((module, index) => ({
                        ...module,
                        order: index + 1
                    }));

                    const response = await axios.post('/modules/reorder', { modules: updatedModules });

                } else { //parent
                    updatedModules = this.modules.map((module, index) => ({
                        ...module,
                        order: index + 1,
                    }));

                    const response = await axios.post('/modules/reorder', { modules: updatedModules });
                }

                toastr.success('Module order updated successfully!');
            } catch (error) {
                toastr.error('Error saving module order.');
            }
            loader.hide();

        },
        openEditModal(module) {
            this.moduleToEdit = { ...module }; 
            this.isEditing = true;
        },
        async saveModule(updatedModule) {
            let loader = this.$loading.show();

            const index = this.modules.findIndex((module) => module.id === updatedModule.id);
            this.modules[index] = updatedModule;

            try {
                await axios.put(`/modules/${updatedModule.id}`, updatedModule);
                toastr.success('Module updated successfully!');
            } catch (error) {
                toastr.error(error, 'Validation Error', 'Error');

            }

            // Close the modal after saving
            this.isEditing = false;
            this.fetchModules();
            loader.hide();

        },
        async deleteModule(deleteModule) {
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
                    await axios.delete(`/modules/${deleteModule.id}`, deleteModule);
                    toastr.success('Module deleted successfully!');
                } catch (error) {
                    toastr.error('Error deleting the module.', 'Error');
                }

                this.fetchModules();
                loader.hide();
            }
        },
        selectModule(module) {
            this.$emit('moduleSelected', module);
        },
       

    },
};
</script>

<style scoped>
.bg-white {
    background-color: white;
}

.border-r {
    border-right: 1px solid #e5e7eb;
}

.drag-handle {
    cursor: move;
}

.child-list {
    padding: 0;
    margin: 0;
}

.child-item {
    padding: 8px 12px;
    border-bottom: 1px solid #e5e7eb;
    cursor: move;
}

li::marker {
    content: '';
}
</style>
