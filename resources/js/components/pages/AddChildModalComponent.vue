<template>
    <div v-if="isVisible" class="fixed inset-0 bg-gray-800 bg-opacity-50 z-50">
        <div class="bg-white p-6 rounded-lg w-1/3 mx-auto">
            <h3 class="text-lg font-bold">Add Child Module</h3>
            <input v-model="newChildName" type="text" placeholder="Enter child module name" class="w-full p-2 border rounded mt-4" />

            <div v-if="validationErrors.name" class="text-red-500 text-sm">{{ validationErrors.name }}</div>
            <div class="mt-4 flex justify-end">
                <button @click="saveChildModule" class="bg-blue-500 text-white px-4 py-2 rounded mr-2">Save</button>
                <button @click="closeModal" class="bg-gray-500 text-white px-4 py-2 rounded">Cancel</button>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "AddChildModalComponent",
    props: {
        isVisible: Boolean,
    },
    data() {
        return {
            newChildName: '',
            validationErrors: {},
        };
    },
    methods: {
        closeModal() {
            this.$emit('close');
            this.newChildName = '';

        },
        saveChildModule() {

            if (!this.newChildName.trim()) {
                this.validationErrors.name = 'Child module name is required.';
                return;
            }
            this.$emit('save', this.newChildName);
            this.newChildName = '';
        },
    },
};
</script>
