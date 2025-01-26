import LoginComponent from "../../components/auth/LoginComponent.vue";
import RegisterComponent from "../../components/auth/RegisterComponent.vue";

export default [
    {
        path: '/login',
        component: LoginComponent,
        name: 'auth.login',
        meta: {
            auth: false
        }
    },
    {
        path: '/register',
        component: RegisterComponent,
        name: 'auth.register',
        meta: {
            auth: false
        }
    },
];
