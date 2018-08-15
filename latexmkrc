# .latexmkrc starts
$pdf_mode = 1;
$sleep_time = 2;
$pdflatex = "pdflatex -file-line-error --synctex=1 -interaction=nonstopmode %O %S";
$preview_continuous_mode = 1;
$pdf_previewer = "start evince";
$pdf_update_method = 0;
# .latexmkrc ends
