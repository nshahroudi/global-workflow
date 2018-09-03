      SUBROUTINE TRUIJX(ALAT,ALONG,XI,XJ,KEIL,IRET_TIJ)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C                .      .    .                                       .
C SUBPROGRAM:    TRUIJX      COMPUTE I/J GRID COORDS FROM LAT/LONG
C   PRGMMR: SHIMOMURA        ORG: W/NP12     DATE: 96-09-23
C
C ABSTRACT: CONVERT A LOCATION FROM GIVEN LAT/LONG COORDINATES
C   TO GRID I/J COORDINATES.
C
C PROGRAM HISTORY LOG:
C   YY-MM-DD  ORIGINAL AUTHOR(S)'S NAME(S) HERE
C   91-10-25  LILLY ADDED DOCBLOCK
C   96-09-23  SHIMOMURA: CONVERTED 91-10-23 VERSION TO CRAY
C                SINCE I ADDED RETURN CODE TO CALL SEQUENCE,
C                I CHANGED THE NAME OF THIS VERSION TO "TRUIJX"
C
C USAGE:    CALL TRUIJX(ALAT, ALONG, XI, XJ, KEIL, IRET_TIJ)
C   INPUT ARGUMENT LIST:
C     ALAT     - REAL LATITUDE IN DEGREES NORTH
C     ALONG    - REAL LONGITUDE IN DEGREES WEST  (HOW IS EAST PUT?)
C     KEIL     - INT  CODE FOR THE GRID BEING USED
C
C   OUTPUT ARGUMENT LIST:
C     XI       - REAL GRID I-COORDINATE
C     XJ       - REAL GRID J-COORDINATE
C     IRET_TIJ - RETURN CODE
C              = 0;  NORMAL RETURN
C              =170; GIVEN ARG:KEIL IS OUT OF RANGE
C
C   OUTPUT FILES:
C     FT06F001 - INCLUDE IF ANY PRINTOUT
C
C REMARKS:
C     CAUTION: 96-09-23/DSS -- I CHANGED CALL SEQUENCE TO ADD A RETURN 
C              CODE, SINCE THE OLD VERSION HAD A STOP.
C
C     CAUTION: 96-09-23/DSS -- I HAND-COPIED MODS FROM A VERSION FOUND 
C              IN PLOT250V PACKAGE.
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  CRAY
C
C$$$
C     ...TO COMPUTE I/J FROM GIVEN LAT/LONG...
C     ...   ON THE GRID SPECIFIED BY KEIL...
C
C     ...KEIL=1  FOR LFM GRID
C     ...KEIL=2  FOR STD NMC GRID
C     ...KEIL=3  FOR SRN HEMI 381KM GRID INT., 80W IS VERT. AT TOP,
C                       SRN HEMI LATS HAVE NEG. VALUES
C     ...KEIL=4  (USED FOR PEATMOS POP) 190.5 KM GRID LENGTH,
C     ...KEIL=5  FOR SFC US 1/10M    ADDED  23 FEB  73
C     ...KEIL=6  FOR LARGER AREA SFC US 1/10M ADDED 12 JUNE 75 ...
C     ...KEIL=7  FOR LARGE NH 1/20M 105W FRONT 2/3   20 OCT 1975 ...
C     ...KEIL=8  FOR LARGE NH 1/20M BACK PANEL SIDEWAYS 20 OCT 75 ...
C     ...KEIL=9  FOR 65*65 N.HEMI 1/40M W/ 105W VERTICAL ... JAN 16, 76
C     ...KEIL=10 FOR 47*51 N.HEMI 1/40M W/ 105W VERTICAL ... JAN 16, 76
C     ...KEIL=11 FOR 51*51 LFM SUBSET OF 1/40M W/ 105W VERTICAL 1/16/76
C     ...KEIL=12 FOR 53*57 FULL LFM GRID W/ 105W VERTICAL 7/22/76
C     ...KEIL=13 FOR 43*31 LFM SUBSET W/ 105W VERT 7/23/76
C     ...KEIL=14 FOR 65*65 STD NMC GRID NHEMI W/80W VERT 7/7/77
C     ...KEIL=15 FOR 55*42 NA AFOS W/105W VERTICAL    MAR 16,1981
C     ...KEIL=16 FOR LARGE SH 1/20M W/ 60W VERTICAL   APR 30, 1981
C     ...KEIL=17 FOR 87*71 NH 1/20M W/105W VERTICAL   JUN 9, 1982
C     ...KEIL=18 FOR 48*44 NH 1/20M W/102.5W VERT (DLY WEA MAP) 9/26/82

C     ...RE ASSUMES 6371.2 KM EARTH RADIUS   ...

      INTEGER    MXKEIL
      PARAMETER (MXKEIL=18)
C     ...WHERE KEIL IS MAX NO. OF GRIDS THIS S/R WORKS FOR

      REAL   XIP(MXKEIL)
      REAL   XJP(MXKEIL)
      REAL   RE(MXKEIL)
      REAL   ADDLNG(MXKEIL)

C     ...              KEIL   =1       =2        =3        =4
C     ...                     LFM      STD NMC   SRN       PEATMOS
      DATA     XIP /         24.0,     24.0,     24.0,     24.0,
     X             -35.0,-11.0,55.0,-15.0,
     Y              33.0, 24.0,26.0, 27.0, 17.0,
     Z              33.0, 27.0, 55.0, 40.0, 21.0 /

      DATA     XJP /         46.0,     26.0,     26.0,     46.0,
     X              2*47.0,    51.0, 55.0,
     Y              33.0, 26.0,46.0, 49.0, 46.0,
     Z              33.0, 46.0, 65.0, 73.0, 48.0 /

      DATA     RE /          62.40866, 31.20433, 31.20433, 62.40866,
     X              2*124.81733, 2*62.40866,
     Y              2*31.20433,  3*62.40866, 31.20433, 2*62.40866,
     Z              93.61299, 62.40866 /

      DATA     ADDLNG /      75.0,    100.0,     80.0,     82.0,
     X             -15.0,-15.0,75.0,165.0,
     Y              5*75.0,
     Z              100.0, 75.0, 60.0, 75.0, 77.5  /

C     ...    VERT MERIDIAN... 105W     80W       100E      98W     ...
C     ...KEIL=5 AND =6 HAVE VERT MERIDIAN AT 195 W ...
C     ...KEIL=7  VERT MERID IS 105W,  KEIL=8  VERT MERID IS 15W ...
C     ...KEIL=9,10,11,12,13  HAVE VERT MERIDIAN AT 105W
C     ...KEIL=14 80W VERT
C     ...KEIL=15 105W VERTICAL
C     ...KEIL=16  60W VERTICAL
C     ...KEIL=17 105W VERTICAL
C     ...KEIL=18 102.5W VERT


      REAL     CONVT
      DATA     CONVT     /1.745329E-02/

C     . . . . . . . . . . . 
      REAL     ALAT
      REAL     ALONG
      REAL     XI
      REAL     XJ
      INTEGER  KEIL
      INTEGER  IRET_TIJ
C     . . . . . . . . . . .
      REAL     XLAT
      REAL     WLONG
      SAVE 
C     . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

      IRET_TIJ = 0
      XI = 0.0
      XJ = 0.0

      KEY = KEIL
      IF((KEY .LE. 0) .OR. (KEY .GT. MXKEIL)) THEN
C       ...COMES HERE IF GIVEN KEIL WAS OUT OF ALLOWABLE RANGE
        WRITE(6,FMT='(1H ,/1H ,''TRUIJX: ERROR.  ARGUMENT "KEIL"'',
     1                         '' OUT-OF-RANGE.  KEIL= HEX '', Z8.8)')
     A          KEIL
        IRET_TIJ = 170
        GO TO 999
      ENDIF

C     ...OTHERWISE, KEIL IS W/I RANGE
      IF((KEY .EQ. 3) .OR. (KEY .EQ. 16)) THEN
C       ...FALLS THRU TO HERE FOR SRN HEMI ONLY...
        XLAT = -ALAT * CONVT
        WLONG = 360.0 - ALONG
        WLONG = (WLONG + ADDLNG(KEY)) * CONVT

      ELSE
        XLAT = ALAT * CONVT
        WLONG = (ALONG + ADDLNG(KEY)) * CONVT

      ENDIF

      R = (RE(KEY) *  COS(XLAT)) / (1.0 +  SIN(XLAT))
      XI = XIP(KEY) + R*SIN(WLONG)
      XJ = XJP(KEY) + R*COS(WLONG)
      GO TO 999

  999 CONTINUE
      RETURN
      END