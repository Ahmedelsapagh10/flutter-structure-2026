import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/forget_password_repo.dart';
import 'state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordRepo repo;

  ForgetPasswordCubit(this.repo) : super(ForgetPasswordInitial());

  Future<void> sendCode(String email) async {
    emit(ForgetPasswordLoading());
    final result = await repo.sendCode(email);
    result.fold(
      (failure) => emit(ForgetPasswordError('Server failure occurred. Please try again.')),
      (response) {
        if (response.success) {
          emit(ForgetPasswordCodeSent(email));
        } else {
          emit(ForgetPasswordError(response.message));
        }
      },
    );
  }

  Future<void> verifyCode(String email, String code) async {
    emit(ForgetPasswordLoading());
    final result = await repo.verifyCode(email, code);
    result.fold(
      (failure) => emit(ForgetPasswordError('Invalid verification code.')),
      (response) {
        if (response.success) {
          emit(ForgetPasswordCodeVerified(email, code));
        } else {
          emit(ForgetPasswordError(response.message));
        }
      },
    );
  }

  Future<void> resetPassword(
      String email, String code, String newPassword, String confirmPassword) async {
    emit(ForgetPasswordLoading());
    final result =
        await repo.resetPassword(email, code, newPassword, confirmPassword);
    result.fold(
      (failure) => emit(ForgetPasswordError('Failed to reset password. Please try again.')),
      (response) {
        if (response.success) {
          emit(ForgetPasswordSuccess(response.message));
        } else {
          emit(ForgetPasswordError(response.message));
        }
      },
    );
  }

  void reset() {
    emit(ForgetPasswordInitial());
  }
}
