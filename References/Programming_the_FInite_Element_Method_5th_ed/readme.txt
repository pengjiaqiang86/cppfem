**************************************************************************
Installation instructions for Windows Users

Created by

Vaughan Griffiths

Colorado School of Mines
September 2013

**************************************************************************

The following instructions explain how you can download and run the
programs in the text:

"Programming the Finite element Method"
 by
 I.M. Smith, D.V. Griffiths and L. Margetts,
 5th edition,
 John Wiley and Sons 2014

Both source code (in Fortran 95/03) and executable versions of all the program
are included in the download.

This readme.txt file is in five parts as follows:

A) Instructions for downloading all the programs, executables and
   subroutines.

B) Instructions for downloading gsview.exe, which is software for
   previewing and printing PostScript files produced by some of the
   programs.

C) Instructions for running executable versions of the finite element
   programs.

D) Instructions for downloading a free Fortran 95/03 compiler.
   This will be needed if you want to change any of the main programs
   or subroutines, or add new subroutines to the finite element libraries.

E) Instructions for running source versions of the finite element programs.

***************************************************************************

A) Instructions for downloading the programs and subroutines.

    From web site http://www.mines.edu/~vgriffit/5th_ed/Software,
    click on 5th_ed.exe, select "Run", choose the folder you want to Unzip to
    (or accept the default of c:\5th_ed).

    When it has finished you will have installed 462 files and 37 folders.

    You are free to select any installation folder you wish for 5th_ed, but
    the following instructions assume you have accepted the default
    installation folder of c:\5th_ed.

***************************************************************************

B) Instructions for downloading gsview.exe, which is software for
   previewing and printing PostScript files produced by some of the
   programs.

    From web site http://www.mines.edu/~vgriffit/5th_ed/Software,
    click on gstools.exe, select "Run", choose the folder you want to Unzip to
    (or accept the default of c:\gstools).

    When it has finished you will have installed 279 files and 3 folders.

    You are free to select any installation folder you wish for gstools, but
    the following instructions assume you have accepted the default
    installation folder of c:\gstools.

    The main executable file needed with some of the programs in this finite
    element system is c:\gstools\gsview\gsview32.exe. This application
    enables PostScript files to be previewed and printed. It is suggested
    that you create a desktop icon for this application so it can easily
    be accessed.

    When executing gsview32.exe for the first time you will need to
    configure it using "Options|Configure"

    In the panel asking "In which directory is Ghostscript located?",
    type c:\gstools\gs5.50 (assuming you accepted the default installation)

    Files can be previewed on the screen by going to File==>Open...  etc,
    or dragging a PostScript file icon into the Ghostscript window.

    During installation you may see a warning of "Configuration failed." 
    This seems to be a false alarm so continue to Exit normally.



***************************************************************************

C) Instructions for running executable versions of the finite element
   programs.

    To run an executable finite element program, say p51.exe from Chapter 5
    in the book with a sample data, say p51_3.dat, navigate in Windows Explorer
    to folder c:\5th_ed\executable\chap05 and double-click on the p51.exe icon

    This should bring up a black command window prompting you to type the
    basename of your data file. At this time type "p51_3" and press Enter.

    Note: All data files in this system MUST have the extension *.dat
    The basename of any data file is the part before the period.

    If the program executes successfully, the results file is given the
    same basename as the data file but with the extension *.res

    In the above example, the results will be held in p51_3.res

    If for example you want to run program p62.exe with your own data,
    navigate in Windows Explorer to folder c:\5th_ed\executable\chap06

    Open the example data file p62.dat that goes with the program using
    any suitable text editor, make whatever changes you wish and then
    Save As... with some other basename. Say you choose to call your data file 
    fred.dat

    Double-click on the p62.exe icon and at the prompt type "fred"

    If the program executes successfully, the results will be held in
    the file fred.res

    Some programs create additional graphics files in PostScript
    which may be previewed using gsview32.exe as described above. These
    graphics files have the same basename as the data file, and the
    following extensions:

    *.msh   which is an image of the finite element mesh
    *.vec   which is an image of the nodal displacement vectors
    *.dis   which is an image of the deformed mesh
    *.con   which is an image of the contour map

    An alternative way of running executable files is to open a black command
    window in the relevant folder. If for example you want to run program p62.exe
    with your own data file called fred.dat simply type on the command line

    p62 fred    followed by "Enter"

    NOTE: In Windows Explorer, the executable files will have the file type "Application" 
    and may not display the extension "*.exe". If this is the case I would suggest 
    going to Tools==>Folder options...==>View and uncheck 
    "Hide extensions for known file types"

***************************************************************************

D) Instructions for downloading a free Fortran 95/03 compiler.

   This will be needed if you want to change any of the main programs or
   subroutines, or add new subroutines to the finite element libraries

   From web site http://www.mines.edu/~vgriffit/5th_ed/Software,
   click on g95-MinGW.exe, select "Run", choose the folder you want to Unzip to
   (or accept the default of c:\g95). Accept all other defaults by clicking
   on "Yes" or "OK" relating to utilities, libs and the PATH.
   You don't need to open the README.txt file.

   Click "OK" to close

*************************************************************************

E) Instructions for running source versions of the programs.

    You must build two libraries called main and geom which is done by running
    a batch file called c:\5th_ed\source\build.bat

    Before running build.bat, it may need to be edited (using Notepad or similar)
    to ensure that environment variables ED5 and G95 point to, respectively,
    the correct installation folders of 5th_ed and g95

    Once you are satisfied that the environment variables are correctly set, go to folder
    c:\5th_ed\source and double-click on build.bat

    There are two ways of running a source finite element program. As an example let's
    try to run program p51.f03 from Chapter 5 in the book with sample data p51_3.dat

    1) In Windows Explorer
       Go to folder c:\5th_ed\source\chap05
       Double-click on runs.exe
       Type in the base name of the program   p51
       Type in the base name of the data file p51_3

    2) Open a black command window in the relevant folder.

       NOTE: The easiest way to open a black command window in the desired folder is
       to move the mouse over some white space in Windows Explorer and right click
       while holding down Shift. Then click on "Open command window here"

       On the command line type

       run5 p51 p51_3 followed by "Enter".

       run5 is always followed by two arguments as shown above. The first
       argument is the basename of the source program (must have extension *.f03)
       and the second argument is the basename of the data file (must have
       extension *.dat).

       DO NOT TYPE THE EXTENSIONS WHEN USING run5

    If the program executes successfully, the results file is
    given the same name as the data file but with the extension
    *.res

    Some programs also produce PostScript graphics output files with the extension
    *.msh, *.dis, *.vec, *.con

    In the above example, the results will be held in p51_3.res and some graphics
    files will be held in p51_3.msh, p51_3.dis, p51_3.vec which can be viewed
    using gsview32.exe


***************************************************************************