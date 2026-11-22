include Makefile
verify:
	$(CC) $(QCADesigner_CFLAGS) $(CFLAGS) -I. "$(VERIFY)/runner.c" $(filter-out QCADesigner-main.o,$(QCADesigner_OBJECTS)) $(QCADesigner_LDADD) -Wl,--wrap=command_history_message,--wrap=set_progress_bar_visible,--wrap=set_progress_bar_label,--wrap=set_progress_bar_fraction -o "$(RUNNER)"
