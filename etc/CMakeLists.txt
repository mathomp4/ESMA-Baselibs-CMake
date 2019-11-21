# Because I'm lazy for now the "files to process" below
# are the files *without* the .in extension

set(files_to_process
   MODULES
   VERSION
   )

foreach(file ${files_to_process})
   configure_file(${file}.in ${file} @ONLY)
   install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${file}
      DESTINATION ${CMAKE_INSTALL_SYSCONFDIR}
      )
endforeach ()
