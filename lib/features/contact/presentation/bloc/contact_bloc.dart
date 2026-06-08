import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/contact/domain/usecases/submit_contact_use_case.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final SubmitContactUseCase _submitContactUseCase;

  ContactBloc(this._submitContactUseCase) : super(const ContactState()) {
    on<ContactSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ContactSubmitted event,
    Emitter<ContactState> emit,
  ) async {
    emit(state.copyWith(status: ContactStatus.loading));
    final result = await _submitContactUseCase(
      name: event.name,
      phone: event.phone,
      message: event.message,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ContactStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ContactStatus.success)),
    );
  }
}
