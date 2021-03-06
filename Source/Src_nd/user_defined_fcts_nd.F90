#include <AMReX_REAL.H>
#include <AMReX_CONSTANTS.H>
#include <AMReX_BC_TYPES.H>
#include <PeleLM_F.H>
#include <AMReX_ArrayLim.H>

module user_defined_fcts_nd_module

  use amrex_fort_module, only : dim=>amrex_spacedim
  use amrex_error_module, only : amrex_abort

  implicit none

  private

  public :: bcfunction, zero_visc

contains

!=========================================================
!  Dummy dimension agnostic bndy fucntion for Dirichlet
!  Need to be duplicated in your run folder
!=========================================================

   subroutine bcfunction( x, dx, dir, norm, time, getuvw, &
                          vel, rho, Yl, T, h)&
                          bind(C, name="bcfunction")

      implicit none

! In/Out      
      REAL_T, intent(in)  :: x(3)
      REAL_T, intent(in)  :: dx(3)
      integer, intent(in) :: dir, norm  ! This specify the direction and orientation of the face
      REAL_T, intent(in)  :: time
      logical, intent(in) :: getuvw
      REAL_T, intent(out) :: vel(3)
      REAL_T, intent(out) :: rho
      REAL_T, intent(out) :: Yl(0:*)
      REAL_T, intent(out) :: T
      REAL_T, intent(out) :: h

      vel(:) = 0.0d0
      rho = 0.0d0
      T = 0.0d0
      h = 0.0d0

      print *,'You are imposing Dirichlet conditions'
      print *,'you need to initialize boundary condition function'
      print *,'in user_defined_fcts_nd.F90'
      call amrex_abort('')

   end subroutine bcfunction

!=========================================================
!  This routine will zero out diffusivity on portions of the
!  boundary that are inflow, allowing that a "wall" block
!  the complement aperture
!
!  INPUTS/OUTPUTS:
!  
!  beta      <=> diffusivity on edges
!  b_lo(hi)   => index extent of beta array
!  lo(hi)     => region of interest, edge-based
!  domlo(hi)  => index extent of problem domain, edge-based
!  dx         => cell spacing
!  problo     => phys loc of lower left corner of prob domain
!  bc         => boundary condition flag (on orient)
!                    in BC_TYPES::physicalBndryTypes
!  idir       => which face, 0=x, 1=y
!  isrz       => 1 if problem is r-z
!  id         => index of state, 0=u
!  ncomp      => components to modify
!=========================================================

   subroutine zero_visc( beta, b_lo, b_hi, lo, hi, domlo, domhi,&
                         dx, problo, bc, idir, isrz, id, ncomp)&
                         bind(C, name="zero_visc")

      use mod_Fvar_def, only : Density, Temp, FirstSpec, RhoH, LastSpec
      use mod_Fvar_def, only : domnhi, domnlo

      implicit none

      integer :: lo(3), hi(3)
      integer :: b_lo(3), b_hi(3)
      integer :: domlo(3), domhi(3)
      integer :: bc(2*3)
      integer :: idir, isrz, id, ncomp
      REAL_T  :: dx(3)
      REAL_T  :: problo(3)
      REAL_T, dimension(b_lo(1):b_hi(1),b_lo(2):b_hi(2),b_lo(3):b_hi(3),*) :: beta

! Routine compiled but should be set by the user
! if there is a mix of inflox/wall at a boundary

   end subroutine zero_visc

end module user_defined_fcts_nd_module
