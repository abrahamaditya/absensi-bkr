import 'package:equatable/equatable.dart';

abstract class KidsEvent extends Equatable {}

class InitEvent extends KidsEvent {
  InitEvent();
  @override
  List<Object?> get props => [];
}

class FetchKidsEvent extends KidsEvent {
  final int page;
  final String searchNameQuery;
  FetchKidsEvent({required this.page, required this.searchNameQuery});
  @override
  List<Object?> get props => [];
}

// Update Kids

class InitUpdateKidsEvent extends KidsEvent {
  InitUpdateKidsEvent();
  @override
  List<Object?> get props => [];
}

class UpdateKidsEvent extends KidsEvent {
  final String id;
  final Map<String, dynamic> updatedData;
  UpdateKidsEvent({required this.id, required this.updatedData});
  @override
  List<Object?> get props => [id, updatedData];
}

// Create Kids

class InitCreateKidsEvent extends KidsEvent {
  InitCreateKidsEvent();
  @override
  List<Object?> get props => [];
}

class CreateKidsEvent extends KidsEvent {
  final Map<String, dynamic> newData;
  CreateKidsEvent({required this.newData});
  @override
  List<Object?> get props => [newData];
}
