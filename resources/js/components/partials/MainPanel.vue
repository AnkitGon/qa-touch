
<template>
    <div class="flex-1 p-6">
        <div v-if="selectedModule">
            <h1 class="text-2xl font-bold text-gray-800 mb-4">
                Test Cases for: {{ selectedModule.name }}
            </h1>

           
            <button @click="openAddTestCaseModal" class="bg-green-500 text-white px-4 py-2 rounded mb-4">
                Add Test Case
            </button>

            
            <div v-if="testCases.length" class="space-y-4">
                <div v-for="testCase in testCases" :key="testCase.id" class="bg-white p-4 rounded shadow">
                    <h3 class="font-medium">{{ testCase.summary }}</h3>
                    <p>{{ testCase.description }}</p>
                    <div class="flex justify-end space-x-2">
                        <button @click="openEditTestCase(testCase)"
                            class="bg-blue-500 text-white px-4 py-2 rounded">Edit</button>
                        <button @click="deleteTestCase(testCase.id)"
                            class="bg-red-500 text-white px-4 py-2 rounded">Delete</button>
                    </div>
                </div>
            </div>
            <div v-else>
                <p>No test cases available. Please add some.</p>
            </div>
        </div>
        <div v-else>
            <p>Select a module to view test cases.</p>
        </div>
    </div>
</template>

<script>
export default {
    props: {
        selectedModule: Object,
        testCases: Array,
    },
    methods: {
        openAddTestCaseModal() {
            this.$emit('openAddTestCaseModal');
        },
        openEditTestCase(testCase) {
            this.$emit('editTestCase', testCase); 
        },
        deleteTestCase(testCaseId) {
            this.$emit('deleteTestCase', testCaseId); 
        },

    },
};
</script>

<style scoped>
.flex-1 {
    flex: 1;
    padding: 1.5rem;
}
</style>
