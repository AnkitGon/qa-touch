<template>
    <div class="min-h-screen bg-gray-100 flex items-center justify-center">
        <div class="bg-white p-8 rounded-lg shadow-lg w-full max-w-md">
            <h2 class="text-2xl font-semibold text-center text-gray-800 mb-6">Register</h2>

            <div class="mt-6" >
                <form @submit.prevent="handleRegister">
                    <div class="mb-4">
                        <label for="registerName" class="block text-gray-700">Full Name</label>
                        <input type="text" id="registerName" v-model="name" class="w-full px-4 py-2 border rounded-md"
                            placeholder="Enter your full name" required />
                    </div>
                    <div class="mb-4">
                        <label for="registerEmail" class="block text-gray-700">Email</label>
                        <input type="email" id="registerEmail" v-model="email" class="w-full px-4 py-2 border rounded-md"
                            placeholder="Enter your email" required />
                    </div>

                    <div class="mb-4">
                        <label for="registerPassword" class="block text-gray-700">Password</label>
                        <input type="password" id="registerPassword" v-model="password"
                            class="w-full px-4 py-2 border rounded-md" placeholder="Enter your password" required />
                    </div>

                    <div class="mb-4">
                        <label for="password_confirmation" class="block text-gray-700">Confirm Password</label>
                        <input type="password" id="password_confirmation" v-model="password_confirmation"
                            class="w-full px-4 py-2 border rounded-md" placeholder="Enter your confirm password" required />
                    </div>

                    <div class="flex justify-between items-center">
                        <button type="submit" class="w-full bg-blue-500 text-white py-2 rounded-md">
                            Regsiter
                        </button>
                    </div>

                    <div id="g_id_onload" :data-client_id="env.GOOGLE_CLIENT_ID" data-callback="handleGoogleLogin"
                        :data-login_uri="env.APP_URL" data-auto_prompt="false"></div>
                </form>
            </div>

        </div>
    </div>
</template>

<script>
import ENV from "../../config/env";
import axios from 'axios';
import toastr from 'toastr';

export default {
    name: "LoginComponent",
    data() {
        return {
            name: '',
            email: '',
            password: '',
            password_confirmation: '',
            env: {
                GOOGLE_CLIENT_ID: ENV.GOOGLE_CLIENT_ID,
                APP_URL: ENV.API_URL,
            }
        };
    },
    methods: {
        handleGoogleLogin(response) {
            const googleToken = response.credential;
            if (googleToken) {
                this.loginWithGoogle(googleToken);
            } else {
                toastr.error('Google login failed', 'Error');

            }
        },
        handleRegister() {
            let loader = this.$loading.show();

            axios.post('/register', {
                name: this.name,
                email: this.email,
                password: this.password,
                password_confirmation: this.password_confirmation,
            })
                .then(response => {
                    localStorage.setItem('user', JSON.stringify(response.data.user));
                    localStorage.setItem('authToken', response.data.token);
                    this.$router.push({ name: 'dashboard' });
                    toastr.success('Welcome ' + response.data.user.name, 'Success');
                })
                .catch(error => {
                    if (error.response && error.response.status === 422) {
                        let error = '';
                        for (const key in error.response.data.errors) {
                            if (error.response.data.errors.hasOwnProperty(key)) {
                                error += error.response.data.errors[key].join(', ') + '\n';
                            }
                        }
                        toastr.error(error, 'Validation Error', 'Error');
                    }
                    else {
                        toastr.error('Something went wrong. Please try again later.', 'Error');
                    }
                });
                loader.hide();                    
                
        },
        loginWithGoogle(googleToken) {
            let loader = this.$loading.show();

            axios.post('/login/google', { token: googleToken })
                .then(response => {

                    localStorage.setItem('user', JSON.stringify(response.data.user));
                    localStorage.setItem('authToken', response.data.token);
                    this.googleLoginSuccess = true;
                    this.$router.push({ name: 'dashboard' });

                    toastr.success('Welcome ' + response.data.user.name, 'Success');

                })
                .catch(error => {
                    toastr.error(error, 'Error');
                });
                loader.hide();                    

        }
    },
    mounted() {

        const script = document.createElement('script');
        script.src = "https://accounts.google.com/gsi/client";
        script.async = true;
        script.defer = true;

        script.onload = () => {
            google.accounts.id.initialize({
                client_id: this.env.GOOGLE_CLIENT_ID,
                callback: this.handleGoogleLogin,
            });

            google.accounts.id.renderButton(
                document.getElementById('g_id_onload'),
                { theme: 'outline', size: 'large' }
            );
        };

        document.head.appendChild(script);
    }
};
</script>
