import 'package:equatable/equatable.dart';
import 'package:absensi_bkr/model/kid_model.dart';

abstract class KidsState extends Equatable {
  const KidsState();
  @override
  List<Object> get props => [];
  get temp => null;
}

class KidsInitial extends KidsState {}

class KidsGetAllData extends KidsState {
  final List<Kid> data;
  const KidsGetAllData(this.data);
  @override
  List<Object> get props => [data];
}

class KidsGetData extends KidsState {
  final List<Kid> data;
  final int totalData;
  final int totalPage;
  final int currentPage;
  const KidsGetData(
      this.data, this.totalData, this.totalPage, this.currentPage);
  @override
  List<Object> get props => [data];
}

class KidsGetAllDataIsEmpty extends KidsState {
  const KidsGetAllDataIsEmpty();
  @override
  List<Object> get props => [];
}

class KidsGetDataIsEmpty extends KidsState {
  const KidsGetDataIsEmpty();
  @override
  List<Object> get props => [];
}

class KidsError extends KidsState {
  final String errMessage;
  const KidsError(this.errMessage);
  @override
  List<Object> get props => [errMessage];
}

//

class KidsUpdateDataSuccess extends KidsState {
  const KidsUpdateDataSuccess();
  @override
  List<Object> get props => [];
}

class KidsUpdateDataFailed extends KidsState {
  const KidsUpdateDataFailed();
  @override
  List<Object> get props => [];
}

//

class KidsCreateDataSuccess extends KidsState {
  const KidsCreateDataSuccess();
  @override
  List<Object> get props => [];
}

class KidsCreateDataFailed extends KidsState {
  const KidsCreateDataFailed();
  @override
  List<Object> get props => [];
}

//

class KidsDeleteDataSuccess extends KidsState {
  const KidsDeleteDataSuccess();
  @override
  List<Object> get props => [];
}

class KidsDeleteDataFailed extends KidsState {
  const KidsDeleteDataFailed();
  @override
  List<Object> get props => [];
}
