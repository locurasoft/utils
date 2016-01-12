(define (create-rotated-knob filepath rotations)
  (define my-angle (/ 270 rotations))
  (let*
	(
   	  (image-src (car (gimp-file-load RUN-NONINTERACTIVE filepath filepath)))
   	  (height-src (car (gimp-image-height image-src)))
   	  (height-dest (* height-src rotations))
   	  (width (car (gimp-image-width image-src)))
	  (image-dest (car (gimp-image-new width height-dest RGB)))
	  (i 0)
	)
	
	(gimp-image-delete image-src)
	
	(while (< i rotations)
	  (let* 
	    (
		  (image-src2 (car (gimp-file-load RUN-NONINTERACTIVE filepath filepath)))
		  (drawable-src (car (gimp-image-get-active-layer image-src2)))
 	      (layer-name (string-append "layer-" (number->string i)))
		  (drawable-dest (car (gimp-layer-new image-dest width height-src RGBA-IMAGE layer-name 100 NORMAL-MODE)))
		  (incr-angle (* i my-angle))
		)
		
 	    (gimp-image-insert-layer image-dest drawable-dest 0 0)
        (gimp-drawable-fill drawable-dest TRANSPARENT-FILL)
	
		(gimp-selection-clear image-src2)
        (gimp-item-transform-rotate drawable-src (* incr-angle (/ *pi* 180)) TRUE (/ width 2) (/ height-src 2))
		(gimp-selection-all image-src2)
		(gimp-edit-copy drawable-src)
		(let* 
		  (
		    (floating-sel (car (gimp-edit-paste drawable-dest TRUE)))
		  )
		  
		  (gimp-floating-sel-attach floating-sel drawable-dest)
		  (gimp-floating-sel-remove floating-sel)
		  (gimp-layer-set-offsets drawable-dest 0 (* i height-src))
		)
		(gimp-image-delete image-src2)
	  )
	  (set! i (+ i 1))
	)
	(gimp-display-new image-dest)
    ;(gimp-file-save RUN-NONINTERACTIVE image-dest drawable filename2 filename2)
  )
  
  ;(gimp-image-delete image)
  
)

(script-fu-register
  "create-rotated-knob"                        ;func name
  "Rotated knob"                                  ;menu label
  "Opens a knob images and generates\
  an multilayered merged and rotated\
  image"              ;description
  "Pascal Collberg"                             ;author
  "copyright 2016, Pascal Collberg"        ;copyright notice
  "12 January, 2016"                          ;date created
  ""                     ;image type that the script works on
  SF-STRING "filepath" ""
  SF-VALUE  "rotations" "128"
)
(script-fu-menu-register "create-rotated-knob" "<Image>/File/Create/Knob")
