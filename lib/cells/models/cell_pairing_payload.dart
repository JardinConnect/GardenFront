class CellPairingDevice {
  final String? deviceId;
  final String? name;
  final String? firmwareVersion;

  const CellPairingDevice({
    this.deviceId,
    this.name,
    this.firmwareVersion,
  });

  factory CellPairingDevice.fromJson(Map<String, dynamic> json) {
    return CellPairingDevice(
      deviceId: json['device_id'] as String?,
      name: json['name'] as String?,
      firmwareVersion: json['firmware_version'] as String?,
    );
  }
}

class CellPairingCell {
  final String? id;
  final String? name;
  final String? parentId;

  const CellPairingCell({
    this.id,
    this.name,
    this.parentId,
  });

  factory CellPairingCell.fromJson(Map<String, dynamic> json) {
    return CellPairingCell(
      id: json['id'] as String?,
      name: json['name'] as String?,
      parentId: json['parent_id'] as String?,
    );
  }
}

class CellPairingPayload {
  final CellPairingDevice? device;
  final CellPairingCell? cell;

  const CellPairingPayload({this.device, this.cell});

  CellPairingPayload copyWith({
    CellPairingDevice? device,
    CellPairingCell? cell,
  }) {
    return CellPairingPayload(
      device: device ?? this.device,
      cell: cell ?? this.cell,
    );
  }
}
