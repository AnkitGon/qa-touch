<template>
    <li class="module-list-item">
        <div class="module-item flex items-center p-2 bg-white rounded shadow hover:bg-gray-100 transition-all ">
            <button v-if="module.children && module.children.length" @click="toggleChildren"
                class="ml-2 text-gray-600 hover:text-gray-800">
                <span v-if="module.isOpen">🔽</span>
                <span v-else>▶️</span>
            </button>

            <span class="ml-2 text-lg font-semibold cursor-pointer" @click="$emit('moduleSelected', module)">
                {{ module.name }}
            </span>
            <button @click="$emit('add-child', module)" class="ml-4 text-green-500 hover:text-green-700">
                <font-awesome-icon :icon="['fas', 'plus']" />

            </button>

            <button @click="$emit('edit', module)" class="ml-4 text-blue-500 hover:text-blue-700">
                <font-awesome-icon :icon="['fas', 'pencil-alt']" />

            </button>
            
            <button @click="$emit('delete', module)" class="ml-4 text-blue-500 hover:text-blue-700">
                <font-awesome-icon :icon="['fas', 'trash']" />
            </button>

            <div class="drag-handle ml-4 cursor-move text-gray-600 hover:text-gray-800">
                <span>:::</span>
            </div>

        </div>

        <draggable v-if="module.isOpen && module.children && module.children.length" :list="module.children"
            group="child-modules" @start="dragging = true" @end="dragging = false" @change="onDragEndChild"
            :itemKey="item => item.id" :move="onMoveChild" :animation="200" :handle="'.drag-handle'" class="inners">
            <template #item="{ element }">
                <ModuleItem :module="element" :key="element.id" @add-child="$emit('add-child', $event)"
                    @edit="$emit('edit', $event)" @delete="$emit('delete', $event)"
                    @moduleSelected="$emit('moduleSelected', $event)" />
            </template>
        </draggable>
    </li>
</template>

<script>
import draggable from "vuedraggable";
import { library } from '@fortawesome/fontawesome-svg-core';
import { faPlus, faPencilAlt, faTrash } from '@fortawesome/free-solid-svg-icons';
library.add(faPlus, faPencilAlt, faTrash)

export default {
    name: "ModuleItem",
    components: {
        draggable,
    },
    data() {
        return {
            dragging: false,
        };
    },
    props: {
        module: {
            type: Object,
            required: true,
        },
    },
    methods: {
        toggleChildren() {
            this.module.isOpen = !this.module.isOpen;
        },
        onMoveChild(evt) {
            return true;
        },
        onDragEndChild(evt) {
         
            this.$emit("saveChildModuleOrder", {
                modules: this.module.children,
            });
            return true;
        },
        editModule() {
            this.$emit('edit', this.module);
        },
    },
};
</script>

<style scoped>
.module-list-item {
    list-style: none;
}

.module-item {
    display: flex;
    align-items: center;
    padding: 8px 12px;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    transition: all 0.3s;
}

.module-item:hover {
    background-color: #f7f7f7;
}

.module-item .drag-handle {
    cursor: move;
    color: #4a4a4a;
}

.module-item button {
    background: none;
    border: none;
    padding: 5px;
    cursor: pointer;
}

.module-item button:hover {
    background-color: rgba(0, 0, 0, 0.05);
}

.module-item span {
    font-size: 16px;
}

.module-item .ml-2 {
    margin-left: 8px;
}

.module-item .ml-4 {
    margin-left: 16px;
}

.module-item .text-green-500:hover {
    color: #38a169;
}

.module-item .text-gray-600:hover {
    color: #2d3748;
}

.inners {
    padding-left: 15px;

}

.module-item .module-item .drag-handle {
    margin-left: 10px;

}

.module-item .module-item button {
    margin-left: 10px;

}
</style>
