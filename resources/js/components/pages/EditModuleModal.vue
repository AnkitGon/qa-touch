<template>
    <div v-if="module" class="modal-overlay">
        <div class="modal-container">
            <h2 class="text-xl font-semibold mb-4">Edit Module</h2>

            <form @submit.prevent="saveChanges">
                <div class="mb-4">
                    <label for="name" class="block text-sm font-medium text-gray-700">Module Name</label>
                    <input
                        v-model="module.name"
                        type="text"
                        id="name"
                        class="mt-1 p-2 w-full border rounded"
                        placeholder="Enter module name"
                        required
                    />
                </div>

                <div class="flex justify-end space-x-4">
                    <button type="button" @click="closeModal" class="bg-gray-300 text-white py-2 px-4 rounded">
                        Cancel
                    </button>
                    <button type="submit" class="bg-blue-500 text-white py-2 px-4 rounded">
                        Save
                    </button>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
export default {
    name: 'EditModuleModal',
    props: {
        module: {
            type: Object,
            required: true,
        },
    },
    methods: {
        saveChanges() {
            this.$emit('save', this.module);
            this.closeModal();
        },
        closeModal() {
            this.$emit('close'); 
        },
    },
};
</script>

<style scoped>
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
}

.modal-container {
    background-color: white;
    padding: 20px;
    border-radius: 8px;
    width: 400px;
    max-width: 100%;
}

.modal-container h2 {
    font-size: 1.25rem;
    font-weight: 600;
    color: #333;
}

input[type="text"] {
    border: 1px solid #ccc;
    border-radius: 4px;
    padding: 8px;
    width: 100%;
}

button {
    cursor: pointer;
}

button:hover {
    opacity: 0.8;
}

.flex {
    display: flex;
}
</style>
