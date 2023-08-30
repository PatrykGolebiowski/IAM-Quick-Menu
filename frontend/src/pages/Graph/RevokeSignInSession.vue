<template>
  <div class="q-pa-md">
    <div v-if="!showResponse">
      <q-form @submit="submitForm" class="q-gutter-md">
        <q-input
          filled
          type="textarea"
          v-model="input"
          label="E-mail addresses (one per line)"
          lazy-rules
          :rules="[(val) => (val && val.length > 0) || 'Please type something']"
        />

        <div>
          <q-btn label="Submit" type="submit" color="primary" />
        </div>
      </q-form>
    </div>

    <div v-else>
      <q-table
        title="User Licenses"
        :rows="flattenedRows"
        :columns="columns"
        :pagination="initialPagination"
        row-key="mail"
      >
        <template v-slot:top-right>
          <q-btn
            color="primary"
            icon-right="archive"
            label="Export to csv"
            no-caps
            @click="exportTable"
          />
        </template> </q-table
      >
    </div>
  </div>
</template>

<script>
import { defineComponent, ref, computed } from "vue";
import { exportFile, useQuasar } from "quasar";
import { useAuthStore } from "src/stores/auth-store";
import { revokeSignInSession } from "src/services/graph_api";

export default defineComponent({
  name: "GraphRevokeSignInSession",

  setup() {
    const $q = useQuasar();

    const auth = useAuthStore();
    const token = auth.accessToken;

    const input = ref(null);
    const graphData = ref(null);
    const showResponse = ref(false);

    // Table //
    const columns = [
      {
        name: "mail",
        required: true,
        label: "User Mail",
        align: "left",
        field: "mail",
        format: (val) => `${val}`,
        sortable: true,
      },
      {
        name: "signInSessionRevoked",
        label: "Sign in session revoked",
        field: "signInSessionRevoked",
        sortable: true,
      },
    ];

    const rows = ref([]);

    const initialPagination = {
      rowsPerPage: 15,
    };

    const flattenedRows = computed(() => {
      return rows.value.map((revoke) => {
        return {
          mail: revoke.mail,
          signInSessionRevoked: revoke.signInSessionRevoked,
        };
      });
    });

    // Functions //

    function submitForm() {
      $q.loading.show();

      const mailsArray = input.value.split("\n"); // Splitting the textarea content into array by newline

      revokeSignInSession(mailsArray, token)
        .then((data) => {
          console.log(data);
          rows.value = data;
          showResponse.value = true;
        })
        .catch((error) => {
          if (error.response && error.response.status === 404) {
            $q.notify({
              type: "negative",
              message: error.response.data.detail,
            });
          } else if (error.message === "Network Error") {
            $q.notify({
              type: "negative",
              message: "Network Error: Unable to reach the server.",
            });
          } else {
            console.error("Error:", error);
            $q.notify({
              type: "negative",
              message: "An error occurred. Please try again later.",
            });
          }
        })
        .finally(() => {
          $q.loading.hide();
        });
    }

    // Table export //

    function wrapCsvValue(val, formatFn, row) {
      let formatted = formatFn !== void 0 ? formatFn(val, row) : val;

      formatted =
        formatted === void 0 || formatted === null ? "" : String(formatted);

      formatted = formatted.split('"').join('""');
      /**
       * Excel accepts \n and \r in strings, but some other CSV parsers do not
       * Uncomment the next two lines to escape new lines
       */
      // .split('\n').join('\\n')
      // .split('\r').join('\\r')

      return `"${formatted}"`;
    }

    function exportTable() {
      // naive encoding to csv format
      const content = [columns.map((col) => wrapCsvValue(col.label))]
        .concat(
          rows.value.map((row) =>
            columns
              .map((col) =>
                wrapCsvValue(
                  typeof col.field === "function"
                    ? col.field(row)
                    : row[col.field === void 0 ? col.name : col.field],
                  col.format,
                  row
                )
              )
              .join(",")
          )
        )
        .join("\r\n");

      const status = exportFile("licenses.csv", content, "text/csv");

      if (status !== true) {
        $q.notify({
          message: "Browser denied file download...",
          color: "negative",
          icon: "warning",
        });
      }
    }

    return {
      input,
      graphData,
      showResponse,

      columns,
      flattenedRows,
      initialPagination,

      submitForm,
      exportTable,
    };
  },
});
</script>
