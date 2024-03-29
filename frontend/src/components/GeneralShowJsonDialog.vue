<template>
    <q-dialog ref="dialogRef" @hide="onDialogHide">
        <q-card class="q-dialog-plugin" style="width: 800px; max-width: 80vw;">
            <q-card-section class="row items-center">
                <q-card-title class="text-h6">JSON Data</q-card-title>
            </q-card-section>
            <q-card-section>
                <pre>{{ formattedData }}</pre>
            </q-card-section>
            <q-card-actions align="right">
                <q-btn color="primary" label="Save" @click="onSaveClick" />
            </q-card-actions>
        </q-card>
    </q-dialog>
</template>

<script>
import { computed } from 'vue'
import { useDialogPluginComponent } from 'quasar'

export default {
    props: {
        data: Object,
        title: String,
    },
    emits: [
        ...useDialogPluginComponent.emits
    ],
    setup(props) {
        const { dialogRef, onDialogHide, onDialogOK, onDialogCancel } = useDialogPluginComponent();
        const formattedData = computed(() => JSON.stringify(props.data, null, 2));

        function onSaveClick() {
            // Create a Blob from the JSON data
            const blob = new Blob([JSON.stringify(props.data, null, 2)], { type: 'application/json' });

            // Create an anchor element and set its href to the blob URL
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = props.title; // Set the file name for download

            // Append the anchor to the body, trigger click to prompt download, then remove the anchor
            document.body.appendChild(a); // Append to body
            a.click(); // Simulate click to trigger download
            document.body.removeChild(a); // Remove element from body

            // Revoke the blob URL to free up resources
            URL.revokeObjectURL(url);
        }

        return {
            dialogRef,
            formattedData,
            onSaveClick,
            onDialogHide,
        };
    }
}
</script>