subroutine  STOMC
  use simsphere_mod

!      INCLUDE 'modvars.h'

!  Calculates the critical stomatal resistance for the
!  critical ground water potential

  FPSICE = 1 + B1 * PSICE

  RSCRIT = RMIN * FS * FPSICE * FT

  return
end
