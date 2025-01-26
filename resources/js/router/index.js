import { createRouter, createWebHistory } from 'vue-router';
import authRoutes from "./modules/authRoutes.js";
import DashboardComponent from '../components/DashboardComponent.vue';
import NotFoundComponent from '../components/pages/NotFoundComponent.vue';

const baseRoutes = [
    {
        path: "/",
        redirect: { name: "auth.login" },
        name: "root"
    },
    {
        path: "/dashboard",
        name: "dashboard",
        component: DashboardComponent,
        meta: {
            auth: true,
        },
    },
    {
        path: "/:pathMatch(.*)*",
        name: "notfound",
        component: NotFoundComponent,
    },
];

const routes = baseRoutes.concat(
    authRoutes,
);
const base = window.location.pathname.split('/').slice(0, -1).join('/');

const router = createRouter({
    history: createWebHistory(base || '/'),
    routes,
});

router.beforeEach((to, from, next) => {
    const isAuthenticated = localStorage.getItem('authToken') !== null;

    if (to.meta.auth && !isAuthenticated) {
        next({ name: 'auth.login' });
    } else {
        next();
    }
});

export default router;
