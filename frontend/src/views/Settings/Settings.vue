<template>
    <div class="q-pa-md">
        <div class="q-gutter-y-md" style="max-width: 600px">

            <SettingsEnvironmentsBar />
            <SettingsEnvironmentsData />

        </div>
    </div>
</template>

<script>
import SettingsEnvironmentsBar from '@/components/SettingsEnvironmentsBar.vue';
import SettingsEnvironmentsData from '@/components/SettingsEnvironmentsData.vue';

export default {
    components: {
        SettingsEnvironmentsBar,
        SettingsEnvironmentsData
    },
    setup() {

        return {

        }
    }
}
</script>