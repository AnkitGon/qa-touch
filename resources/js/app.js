import { createApp } from 'vue';
import router from './router';
import ENV from './config/env';
import axios from 'axios';
import App from './App.vue';
import 'toastr/build/toastr.min.css';
import {LoadingPlugin} from 'vue-loading-overlay';
import 'vue-loading-overlay/dist/css/index.css';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import SweetAlert2 from './plugins/sweetalert'

const API_URL = ENV.API_URL;
const API_KEY = ENV.API_KEY;

axios.defaults.baseURL = API_URL + '/api';

axios.interceptors.request.use(
    config => {
        if (API_KEY) {
            config.headers['x-api-key'] = API_KEY;
        }

        const token = localStorage.getItem('authToken');
        if (token) {
            config.headers['Authorization'] = `Bearer ${token}`;
        }

        return config;
    },
    error => Promise.reject(error)
);


const app = createApp(App);
app.use(router)
app.use(LoadingPlugin);
app.component('font-awesome-icon', FontAwesomeIcon)
app.use(SweetAlert2)
app.mount('#app');
