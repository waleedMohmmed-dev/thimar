import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/faq/domain/usecases/get_faqs_use_case.dart';
import 'faq_event.dart';
import 'faq_state.dart';

class FaqBloc extends Bloc<FaqEvent, FaqState> {
  final GetFaqsUseCase _getFaqsUseCase;

  FaqBloc(this._getFaqsUseCase) : super(const FaqState()) {
    on<FaqFetched>(_onFetched);
  }

  Future<void> _onFetched(FaqFetched event, Emitter<FaqState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getFaqsUseCase(const NoParams());
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (faqs) => emit(state.copyWith(isLoading: false, faqs: faqs)),
    );
  }
}
