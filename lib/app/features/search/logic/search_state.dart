// lib/app/features/search/logic/search_state.dart

import 'package:iti_grad_proj/app/features/persons/data/models/person_model.dart';

sealed class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<PersonModel> persons;
  const SearchLoaded(this.persons);
}

class SearchEmpty extends SearchState {
  const SearchEmpty();
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
}
