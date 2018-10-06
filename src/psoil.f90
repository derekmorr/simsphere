subroutine  PSOIL
  use simsphere_mod
  implicit none

  real :: OMA, SFFK, ZETA, XINCR, CORR
  integer :: NLVL1, I, II

!      INCLUDE 'modvars.h'

  DATA OMA , SFFK / 0.0000727 , 4 /

  ZETA = 0
  DZETA = 1

! Calc. LAMBDA, KAPPA & Volumetric Heat Capacity of the ground (CG).
! See manual for explanation of Lamda & Kappa.

! Rob Gillies 01/11/95
! The Thermal Inertia (TP) is entered in TI (Wm-2K-1) units
! Convert to cgs to be able to use regression equation derived
! from Sellers. This regression equation should be redone with
! MKS units which will then prevent all this cafuffle !!

!      INITIATE DUAL TI OPTION BY TNC DAJR, 15 MARCH, 1996

  IF(DUAL_TI == 'Y') THEN
    TP = TI_A * F + TI_B
  ENDIF

  TP = TP / 356.89466 ! Conversion to cal cm-1 K-1 s-1/2

! These are TP as a function of the surface moisture availability

!    TP  = F * 0.04000 + 0.02000 !  Toby's Generic Soil
!       TP  = F * 0.03000 + 0.03400 !  Toby's FIFE Soil
!       TP  = F * 0.04600 + 0.01400 !  Price's Sand
!       TP  = F * 0.03890 + 0.01290 !  Price's Clay
!        TP  = F * 0.04241 + 0.01349 !  Price's AVG(Sand,Clay)
!      TP  = F * 0.03000 + 0.00690 !  Price's Peat
!  TP = F * 0.04600 + 0.04500  !  Walnut Gultch


  LAMBDA = -0.00013 + 0.0502 * TP + 1.21 * TP**2
  KAPPA = LAMBDA**2 / TP**2
  KAPPA = KAPPA/1.0E4 ! NOW CONVERT TO MKS; TP ENTERED IN CGS
  LAMBDA = LAMBDA * 418.68
  CG = LAMBDA / KAPPA

! Find the best depth profile as a function of Kappa.
! The followig calcs are used in BELOW.  Creates a temp profile
! in the soil. Figure levels using scheme by Deardroff.

! DEL is set to numerically stable value.
! Initial temp's at substrate levels (NLVLS) calc'd based on
! a linear interpolation between OTEMP & BTEMP.

  NLVL1 = NLVLS + 1
  DEL = SQRT( SFFK * DELTA * KAPPA ) / ( EXP(DZETA) - 1 )
  XINCR = ( BTEMP - OTEMP ) / NLVLS
  TT(1) = OTEMP
  TT(NLVL1) = BTEMP

  do II = 2 , NLVLS
    TT(II) = TT(II-1) + XINCR
  end do

! Here the substrate spacing ( depth ) is being calc'd based on the
! on the scale depth (h = (1+z/d).

  do I = 1 , NLVL1
    Z(I) = (EXP( ZETA ) - 1 ) * DEL
    XFUN(I) = ( 1 + Z(I) / DEL )
    ZETA = ZETA + DZETA
  end do

! Correction of LAMBDA to account for reduction in temp wave in 1st
! soil layer. Consult manual for explanation.

! Label identified as unused by compiler
!** 7678 CONTINUE

  CORR = 2 / ( 1 + EXP( -Z(2) * SQRT( OMA / ( 2 * KAPPA ) ) ) )
  LAMBDA = CORR * LAMBDA

! Initialise W2G and WGG, the substrate water budget patameters.
! Deardorff (1978).

   W2G = WMAX * FSUB
   WGG = WMAX * F

   return
end
