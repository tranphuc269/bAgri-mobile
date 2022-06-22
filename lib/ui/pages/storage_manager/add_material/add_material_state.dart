part of 'add_material_cubit.dart';

class AddMaterialState extends Equatable {
  Material? material;

  // final String? description;
  LoadStatus? loadingStatus;
  String? name;
  String? unit;
  int? quantity;
  int? unitPrice;

  AddMaterialState({
    this.material,
    this.unit,
    this.unitPrice,
    this.name,
    this.quantity,
    // this.description,
    this.loadingStatus,
  });

  AddMaterialState copyWith({
    Material? material,
    // final String? description,
    LoadStatus? loadingStatus,
    String? name,
    String? unit,
    int? quantity,
    int? unitPrice

  }) {
    return AddMaterialState(
      material: material ?? this.material,
      name: name ?? this.name,
      unitPrice: unitPrice ?? this.unitPrice,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      // description: description ?? this.description,
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }

  bool get buttonEnabled {
    if (name == null ||
        unit == null ||
        unitPrice == null ||
        quantity == null)
      return false;
    else if (name!.isEmpty)
      return false;
    else
      return true;
  }

  @override
  List<Object?> get props => [
        this.material,
        this.name,
        this.quantity, this.unitPrice, this.unit,
        // this.description,
        this.loadingStatus,
      ];
}
