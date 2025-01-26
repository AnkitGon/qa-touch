<template>
    <div v-if="isVisible" class="fixed inset-0 flex items-center justify-center bg-gray-800 bg-opacity-50 z-50">
        <div class="bg-white p-6 rounded-lg w-1/3">
            <h2 class="text-xl font-bold mb-4">Add Module</h2>

            <select v-model="newModule.parent_id" class="border p-2 rounded w-full mb-4"
                :class="{ 'border-red-500': validationErrors.parent_id }">
                <option value="" disabled>Select Parent Module </option>
                <option :value="null">Root</option> <!-- Change value to null -->
                <option v-for="module in modules" :key="module.id" :value="module.id">
                    {{ module.name }}
                </option>
            </select>

            <div v-if="validationErrors.parent_id" class="text-red-500 text-sm">{{ validationErrors.parent_id }}</div>


            <input v-model="newModule.name" type="text" placeholder="Enter module name"
                class="border p-2 rounded w-full mb-4" :class="{ 'border-red-500': validationErrors.name }"
                aria-label="Module name" aria-required="true" />

            <div v-if="validationErrors.name" class="text-red-500 text-sm">{{ validationErrors.name }}</div>

            <div class="flex justify-end">
                <button @click="saveModule" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"
                    :disabled="isSaving">
                        Save Module
                </button>
                <button @click="closeModal" class="ml-2 bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600">
                    Cancel
                </button>
            </div>
        </div>
    </div>
</template>

<script>
import toastr from 'toastr';
import axios from 'axios';

export default {
    name: "ModalComponent",
    props: {
        isVisible: {
            type: Boolean,
            default: false,
        },
    },
    data() {
        return {
            newModule: {
                name: '',
                parent_id: null,
            },
            modules: [],
            isSaving: false,
            validationErrors: {},
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
                toastr.error('Failed to fetch modules.');
            }
            loader.hide();                    

        },

        closeModal() {
            this.$emit('close');
            this.newModule.name = '';
            this.newModule.parent_id = null;
        },

        async saveModule() {
            this.validationErrors = {};
            let isValid = true;

            if (!this.newModule.name.trim()) {
                this.validationErrors.name = 'Module name is required.';
                isValid = false;
            }

            if (this.newModule.parent_id === '') {
                this.validationErrors.parent_id = 'Please select a parent module.';
                isValid = false;
            }
            if (!isValid) {
                return;
            }

            this.isSaving = true;
            try {
                await this.$emit('save', this.newModule);
                
                this.closeModal();
            } catch (error) {
                toastr.error('Failed to add module.');
            } finally {
                this.isSaving = false;
            }
        },

    },
};
</script>

<style scoped>
.border-red-500 {
    border-color: #f56565;
}

.text-red-500 {
    color: #f56565;
}

.bg-gray-800 {
    background-color: rgba(0, 0, 0, 0.8);
}
</style>
