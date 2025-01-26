<template>
    <nav class="bg-blue-500 text-white py-4">
        <div class="container mx-auto flex justify-between items-center">
            <h1 class="text-xl font-bold">{{ user?.name || '' }}</h1>
            <ul class="flex space-x-4">
                <li>
                    <button @click="logout" class="hover:underline">Logout</button>
                </li>
            </ul>
        </div>
    </nav>
</template>

<script>
export default {
    data() {
        return {
            user: null,
        };
    },
    mounted() {
        const storedUser = localStorage.getItem('user');

        if (storedUser) {
            this.user = JSON.parse(storedUser);
        }

    },
    methods: {
        logout() {
            localStorage.removeItem('authToken');
            localStorage.removeItem('user');
            this.user = null;
            this.$router.push({ name: 'auth.login' });
        },
    },
};
</script>
