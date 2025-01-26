<template>
    <div class="min-h-screen bg-gray-100 flex items-center justify-center">
        <div class="text-center">
            <h1 class="text-6xl font-bold text-red-600">404</h1>
            <p class="mt-4 text-gray-800">Page Not Found</p>
            <router-link to="/" class="mt-4 text-blue-500 underline">Go to Home</router-link>
        </div>
    </div>
</template>

<script>
export default {
    name: 'NotFoundComponent',
};
</script>
