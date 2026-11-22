#include <gtk/gtk.h>
#include <stdarg.h>
#include "fileio.h"
#include "coherence_vector.h"
#include <stdlib.h>
#include "global_consts.h"
#include "print.h"
#include "objects/QCADSubstrate.h"
#include "objects/QCADLabel.h"

print_design_OP print_options;
extern coherence_OP coherence_options;
void __wrap_command_history_message(char *format, ...) {
    va_list args;
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
}
void __wrap_set_progress_bar_visible(gboolean visible) {}
void __wrap_set_progress_bar_label(char *label) {}
void __wrap_set_progress_bar_fraction(double fraction) {}

int main(int argc, char **argv) {
    if (argc != 3) return 2;
    gtk_init(&argc, &argv);
    g_type_class_ref(QCAD_TYPE_LAYER);
    g_type_class_ref(QCAD_TYPE_CELL);
    g_type_class_ref(QCAD_TYPE_SUBSTRATE);
    g_type_class_ref(QCAD_TYPE_LABEL);
    DESIGN *design = NULL;
    if (!open_project_file(argv[1], &design) || !design) return 3;
    srand(1);
    simulation_data *data = run_coherence_simulation(EXHAUSTIVE_VERIFICATION, design, &coherence_options, NULL);
    if (!data || data->number_of_traces != 12) return 4;
    FILE *out = fopen(argv[2], "w");
    if (!out) return 4;
    for (int i = 0; i < data->number_of_traces; ++i)
        fprintf(out, "%s%s", i ? "," : "", data->trace[i].data_labels);
    fputc('\n', out);
    for (int j = 0; j < data->number_samples; ++j) {
        for (int i = 0; i < data->number_of_traces; ++i)
            fprintf(out, "%s%.12g", i ? "," : "", data->trace[i].data[j]);
        fputc('\n', out);
    }
    return fclose(out) != 0;
}
