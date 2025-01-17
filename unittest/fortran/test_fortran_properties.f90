FUNCTION f_lammps_version() BIND(C)
   USE, INTRINSIC :: ISO_C_BINDING, ONLY : c_int
   USE liblammps
   USE keepstuff, ONLY : lmp
   IMPLICIT NONE
   INTEGER(c_int) :: f_lammps_version

   f_lammps_version = lmp%version()
END FUNCTION f_lammps_version

SUBROUTINE f_lammps_memory_usage(meminfo) BIND(C)
   USE, INTRINSIC :: ISO_C_BINDING, ONLY : c_double
   USE liblammps
   USE keepstuff, ONLY : lmp
   IMPLICIT NONE
   REAL(c_double), DIMENSION(3), INTENT(OUT) :: meminfo

   CALL lmp%memory_usage(meminfo)
END SUBROUTINE f_lammps_memory_usage

FUNCTION f_lammps_get_mpi_comm() BIND(C)
   USE, INTRINSIC :: ISO_C_BINDING, ONLY : c_int
   USE liblammps
   USE keepstuff, ONLY : lmp
   IMPLICIT NONE
   INTEGER(c_int) :: f_lammps_get_mpi_comm

   f_lammps_get_mpi_comm = lmp%get_mpi_comm()
END FUNCTION f_lammps_get_mpi_comm

FUNCTION f_lammps_extract_setting(Cstr) BIND(C)
   USE, INTRINSIC :: ISO_C_BINDING, ONLY : c_int, c_char
   USE keepstuff, ONLY : lmp
   USE LIBLAMMPS
   IMPLICIT NONE
   INTEGER(c_int) :: f_lammps_extract_setting
   CHARACTER(KIND=c_char, LEN=1), DIMENSION(*), INTENT(IN) :: Cstr
   INTEGER :: strlen, i
   CHARACTER(LEN=:), ALLOCATABLE :: Fstr

   i = 1
   DO WHILE (Cstr(i) /= ACHAR(0))
      i = i + 1
   END DO
   strlen = i
   ALLOCATE(CHARACTER(LEN=strlen) :: Fstr)
   DO i = 1, strlen
      Fstr(i:i) = Cstr(i)
   END DO
   f_lammps_extract_setting = lmp%extract_setting(Fstr)
   DEALLOCATE(Fstr)
END FUNCTION f_lammps_extract_setting

FUNCTION f_lammps_has_error() BIND(C)
   USE, INTRINSIC :: ISO_C_BINDING, ONLY : c_int
   USE keepstuff, ONLY : lmp
   USE LIBLAMMPS
   IMPLICIT NONE
   INTEGER(c_int) :: f_lammps_has_error

   IF (lmp%has_error()) THEN
      f_lammps_has_error = 1_c_int
   ELSE
      f_lammps_has_error = 0_c_int
   END IF
END FUNCTION f_lammps_has_error

FUNCTION f_lammps_get_last_error_message(errmesg, errlen) BIND(C)
   USE, INTRINSIC :: ISO_C_BINDING, ONLY : c_int, c_char, c_ptr, C_F_POINTER
   USE keepstuff, ONLY : lmp
   USE LIBLAMMPS
   IMPLICIT NONE
   INTEGER(c_int) :: f_lammps_get_last_error_message
   CHARACTER(KIND=c_char), DIMENSION(*) :: errmesg
   INTEGER(c_int), VALUE, INTENT(IN) :: errlen
   CHARACTER(LEN=:), ALLOCATABLE :: buffer
   INTEGER :: status, i

   ! copy error message to buffer
   ALLOCATE(CHARACTER(errlen) :: buffer)
   CALL lmp%get_last_error_message(buffer, status)
   f_lammps_get_last_error_message = status
   ! and copy to C style string
   DO i=1, errlen
      errmesg(i) = buffer(i:i)
      IF (buffer(i:i) == ACHAR(0)) EXIT
   END DO
   DEALLOCATE(buffer)
END FUNCTION f_lammps_get_last_error_message
