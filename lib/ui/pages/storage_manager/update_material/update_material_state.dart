part of 'update_material_cubit.dart';

class UpdateMaterialState extends Equatable {
  LoadStatus? loadingStatus;
  String? name;
  String? unit;
  int? quantity;
  int? unitPrice;

  UpdateMaterialState({
    this.unit,
    this.unitPrice,
    this.name,
    this.quantity,
    // this.description,
    this.loadingStatus,
  });

  UpdateMaterialState copyWith({
    LoadStatus? loadingStatus,
    String? name,
    String? unit,
    int? quantity,
    int? unitPrice

  }) {
    return UpdateMaterialState(
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }

  @override
  List<Object?> get props => [
        this.name,
        this.quantity,
        this.unitPrice,
        this.unit,
        this.loadingStatus,
      ];
}
