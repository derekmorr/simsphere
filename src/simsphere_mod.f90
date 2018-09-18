module simsphere_mod
  implicit none
  public

!
! Simsphere module provides parameters and functions used by various other parts of the program.
! This module was originally three "header" files: constants.h, factors.h, and 
! modvars.h.  These files were used via an INCLUDE (or, originally, $INCLUDE for a
! suspected DEC compiler).  The contents have been collected into this module in
! an initial effort to modernize the code.
!

  integer, parameter :: vert_spacing = 250
  integer, parameter :: TRANSM_MAX_PATH = 10
  integer, parameter :: rhow=1000                ! Density of Water
  integer, parameter ::  DELTA = 90

  real, parameter :: rot_rate_earth = 7.27e-5
  real, parameter :: siga = 279.9348
!  real, parameter :: radian = 57.29578
  real, parameter :: dens = 1.1                  ! Density of Air
  real, parameter :: ft = 1.0
  real, parameter :: ZA = 50.0
  real, parameter :: SIGMA = 5.6521E-8
  real, parameter :: LE = 2.5E6
  real, parameter :: KARMAN = 0.4
  real, parameter :: GRAV = 9.78
  real, parameter :: R = 287.5
  real, parameter :: RAD = 1.6E-5
  real, parameter :: CP = 1004.832
  double precision, parameter :: radian = 572957.75913D-4
  double precision, parameter :: sdec = 39784.988432D-5

!    conversion factors (formerly factors.h)
  real, parameter :: Kts_To_Metres = 1.944       ! Knots to ms-1
  real, parameter :: Ft_To_Metres = 3.281        ! Feet to meters
  real, parameter :: Degs_To_Radians = 0.0174533 ! Degrees to Radians
  real, parameter :: Celsius_To_Kelvin = 273.15  ! Celsius to Kelvin

!    COMMON blocks to initialize various things (formerly modvars.h)
! **  This file contains the declaration of the common blocks for the
! **  model.

  real :: KM(50), LAMBDA, KAPPA, LWDN
  real :: u_fine(51),v_fine(51),t_fine(51),q_fine(51)
  real :: ABSTBL(46),BSCTBL(46),SCATBL(46)
  real :: UGS,VGS,ANGL,DTX,DTY,CF
  real :: DELTAZ
  real :: ZI(50),ZK(50)
  real :: UD(50),VD(50),UGD(50),VGD(50)
  real :: XTDIF,YTDIF,XPDIF,YPDIF
  real :: GM(50),TS(50),TD(50),Tdif_50,Tdif_s,O_Pot_Tmp
  real :: TA,TAF,TG,QAF,QSTF,QSTG
  real :: HF,XLEF,XLEG,TF,QA,WIDTH
  real :: RST,UAF,RSF,RSG,RLF,RLG,UTEN
  real :: CHA, CHG, CHF, RTRANW
  real :: KQFLAG,QD(50)=0.0,DQDT2(50),QQ(50),QN(51)
  real :: ATEMP,AWIND,OMEGA,OTEMP,BTEMP,APTEMP
  real :: GBL_sum,OSHUM,XMAX,DQDT,SUMW
  real :: FSUB,F,ZO,TP,TI_A,TI_B,DELZ(8),CG
  real :: GAM,HET
  real :: U(50),V(50),UG(50),VG(50),T(50),ZCOUNT
  real :: OUTTT,SATAM,SATPM,STRTIM, TIMEND, REALTM, PTIME
  real :: DEL,DZETA,Z(9),TT(9),XFUN(9)
  real :: XLAT,XLONG,TZ,IYR,ALBDOE
  real :: WMAX,W2G,WGG,WILT
  real :: EPSI,EPSF,XLAI,SOL,RNETG,RNETF,AEPSI
  real :: SWAVE
  real :: ADVGT
  real :: FRVEG
  real :: TSCREN,PS1,PTM100
  real :: RESIST,EMBAR,RZASCR
  real :: THV,THMAX,PSIG,RKW,VFL,BETA,B1,B2,PSICM,PSICE,SC,ZP,MINTEMP,MAXTEMP,RCUT,RAF,RMIN,VEGHEIGHT
  real :: FS,RSCRIT,PSIWC,PSIM,PSIE,RS,WPSI,RLPSI,FC,FPSIE,RL,ZG,RLELF
  real :: VOLINI,RKOCAP,ZSTINI,FRHGT,FRZP,RZCAP,VOLREL
  real :: PSIST,PSIX,FST,DELTVST,VOLRMV,ZST,CAPACI,FLUXGD,VOLIST,PSISUP
  real :: rks, cosbyb, psis
  real :: FCO2,CCAN,CI,CO,FRCO2
  real :: coz_sfc, coz_air, caf, fglobal, flux_plant, sumo3
  real :: SLOPE, ASPECT
  real :: Y = 1.0
  real :: ALBG = 0.0
  real :: ALBF = 0.0
  real :: XMOD = 0.0
  real :: SIGF = 0.0
  real :: HG = 0.0
  real :: AHUM = 0.0
  real :: RNET = 0.0
  real :: CHGT = 0.0
  real :: USTAR = 0.0
  real :: TSTAR = 0.0
  real :: HEAT = 0.0
  real :: HGT = 50.0
  real :: DELT = 1.0
  real :: CTHETA = 1.0
  real :: DHET = 0.0
  real :: EVAP = 0.0
  real :: MOL = 0.0
  real :: BULK = 0.0


  integer(kind=1) :: cld_fract
  integer :: RCCAP
  integer :: NTRP
  integer :: IMO
  integer :: IDAY
  integer :: IFIRST = 0
  integer :: NLVLS = 5
  integer :: JCAP = 1

  character(len=1) :: STMTYPE, STEADY, DUAL_TI

  logical :: cloud_flag



! Function splint formerly subroutine splint

  contains
    
    real pure function splint(XA,YA,Y2A,n,x)
      integer, intent(in) :: n, x
      real, intent(in) :: XA(50), YA(50), Y2A(n)
    
      real :: h, a, b
      integer :: klo, khi, k
    
      klo=1
      khi=n
    
      do 
        if (khi-klo .le. 1) exit
        if (khi-klo .gt. 1) then
          k=(khi+klo)/2
          if (XA(k) .gt. x) then
            khi=k
          else
            klo=k
          end if
        end if
      end do
    
      H=XA(KHI)-XA(KLO)
      A=(XA(KHI)-X)/H
      B=(X-XA(KLO))/H
      splint=A*YA(KLO)+B*YA(KHI)+((A**3-A)*Y2A(KLO)+(B**3-B)*Y2A(KHI))*(H**2)/6.
    
    end function

! Function spline formerly subroutine spline

    pure function spline(X,Y,N,YP1,YPN)
      integer, parameter :: NMAX=100
      real :: U(NMAX)
      real :: UN,QN,P,SIG
      integer, intent(in) :: N
      integer :: i, k
      real, intent(in) :: X(N), Y(N), YP1, YPN
      real :: spline(N)
    
      IF (YP1.GT..99E30) THEN
        spline(1)=0.
        U(1)=0.
      ELSE
        spline(1)=-0.5
        U(1)=(3./(X(2)-X(1)))*((Y(2)-Y(1))/(X(2)-X(1))-YP1)
      end if
      do I=2,N-1
        SIG=(X(I)-X(I-1))/(X(I+1)-X(I-1))
        P=SIG*spline(I-1)+2.
        spline(I)=(SIG-1.)/P
        U(I)=(6.*((Y(I+1)-Y(I))/(X(I+1)-X(I))-(Y(I)-Y(I-1))                 &
             /(X(I)-X(I-1)))/(X(I+1)-X(I-1))-SIG*U(I-1))/P
      end do
      IF (YPN.GT..99E30) THEN
        QN=0.
        UN=0.
      ELSE
        QN=0.5
        UN=(3./(X(N)-X(N-1)))*(YPN-(Y(N)-Y(N-1))/(X(N)-X(N-1)))
      end if
      spline(N)=(UN-QN*U(N-1))/(QN*spline(N-1)+1.)
      do K=N-1,1,-1
        spline(K)=spline(K)*spline(K+1)+U(K)
      end do
      return
    end function

! Functions from former subroutine transm

    pure function ftabsT(path)
      real :: ftabst, fracp, fract, fract2
      real, intent(in) :: path
      integer :: ipath, jpath

!     Subroutine TRANSM calculates solar transmission by using the
!     three-way lookup table produced in GETTBL.

! **  If the path length is very large (sun almost on the horizon) use
! **  longest path length possible, ie last number in the table. Otherwise
! **  calc trans coeff's for entries bracketing the supplied path length.
! **  FRACTP - Scaling fact for depth of atmos. FRACT & FRACT2 weighting
! **  factors for interpol'n between 2 successive path lenghts in table.

      if ( path >= TRANSM_MAX_PATH ) then
        ftabst = abstbl(size(abstbl))
      else
        fracp = ps1 / 1013.25
        fract= 5 * ( path - 1 ) + 1
        ipath = INT( fract )
        jpath = ipath + 1
        fract = ( fract - ipath )
        fract2 = 1 - fract
        ftabst = fract2 * abstbl( ipath ) + fract * abstbl( jpath )
        ftabst = fracp * ( ftabst - 1 ) + 1
      end if
     end function ftabsT

    pure function ftscatT(path)
      real :: ftscatT, fracp, fract, fract2
      real, intent(in) :: path
      integer :: ipath, jpath

!     Reference comments in ftabsT()

      if ( path >= TRANSM_MAX_PATH ) then
        ftscatT = scatbl(size(scatbl))
      else
        fracp = ps1 / 1013.25
        fract= 5 * ( path - 1 ) + 1
        ipath = INT( fract )
        jpath = ipath + 1
        fract = ( fract - ipath )
        fract2 = 1 - fract
        ftscatT = fract2 * scatbl( ipath ) + fract * scatbl( jpath )
        ftscatT = fracp * ( ftscatT - 1 ) + 1
      end if
    end function ftscatT

    pure function fbscatT(path)
      real :: fbscatT, fracp, fract, fract2
      real, intent(in) :: path
      integer :: ipath, jpath

!     Reference comments in ftabsT()

      if ( path >= TRANSM_MAX_PATH ) then
        fbscatT = bsctbl(size(bsctbl))
      else
        fracp = ps1 / 1013.25
        fract= 5 * ( path - 1 ) + 1
        ipath = INT( fract )
        jpath = ipath + 1
        fract = ( fract - ipath )
        fract2 = 1 - fract
        fbscatT = fract2 * bsctbl( ipath ) + fract * bsctbl( jpath )
      end if
    end function fbscatT



!  Function Definitions for Vel
    
    real function You_star (Wind,Height,Roughness,Stability)
      real(kind=4), parameter :: R_Karman = 0.4
      real :: Wind, Height, Roughness, Stability
    
      You_star = R_Karman * Wind / ((ALOG(Height / Roughness) + Stability))  
    
      return
    end function You_star
    
    



    real function R_ohms (Friction,Height,Roughness,Stability)
      real(kind=4), parameter :: Karman = 0.4
      real(kind=4), parameter :: Konst = 0.74
      real :: Friction, Height, Roughness, Stability
             
      R_ohms = Konst * (ALOG(Height/Roughness) + Stability)/(Karman * Friction)
       
      return
    end function R_ohms
    
    



    real function WindF (Star,Height,Roughness,Stability)
      real(kind=4), parameter :: R_Karman = 0.4
      real :: Star, Height, Roughness, Stability
    
      WindF = (Star / R_Karman)*(ALOG(Height/Roughness) + Stability)
    
      return
    end function WindF
    
    



    real function Stab (Height)
      real :: Height
    
      Stab = (1 - 15 * Height / MOL)**0.25
    
      return
    end function Stab
    
    



    real function StabH (Height)
      real :: Height
    
      StabH = (1 - 9 * Height / MOL)**0.5
           
      return
    end function StabH
    
    
 

    real function FstabH (Par1,Par2)
      real :: Par1, Par2
    
      FstabH = 2 * ALOG(( Par1 + 1) / (Par2 + 1))
           
      return
    end function FstabH
    
    


    real function FstabM (Par1,Par2)
      real :: Par1, Par2
    
      FStabM = ALOG (((Par1**2 + 1 ) * (Par1 + 1 )**2 ) /                   &
                    ((Par2 + 1 ) * (Par2 + 1 )**2 )) + 2 *                  &
                    ( ATAN(Par2) - ATAN(Par1))
           
      return
    end function FstabM
    

    
    real function ResTrn (Star,Roughness,Par3)
      real :: Star, Roughness, Par3
    
      real(kind=4), parameter :: R_KARMAN = 0.4
    
      RESTRN = (ALOG(R_KARMAN* Star*Roughness+Par3) - ALOG(Par3)) / (R_KARMAN  * Star)
    
      return
    end function ResTrn

!
! advect function replaces ADVECT subroutine
!

   real pure function advect ()
     implicit none

     real, parameter :: dz = 1000
     real :: dtdx, dtdy

     dtdx = cf * otemp / (grav * dz) * (vgd(5) - vgd(1))
     dtdy = -cf * otemp / (grav * dz) * (ugd(5) - ugd(1))
     advect = (-(ugd(3) * dtdx + vgd(3) * dtdy))/2

   end function advect

end module simsphere_mod
