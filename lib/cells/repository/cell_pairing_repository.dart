import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:garden_connect/auth/data/auth_repository.dart';
import 'package:garden_connect/auth/utils/http_client.dart';

class CellPairingRepository {
  CellPairingRepository({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository();

  final AuthRepository _authRepository;

  Stream<SSEModel> subscribeToPairing() async* {
    final token = await _authRepository.getToken();
    final headers = <String, String>{
      'Accept': 'text/event-stream',
      'Cache-Control': 'no-cache',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final url = '${HttpClient.baseUrl}/cell/pairing';
    yield* SSEClient.subscribeToSSE(
      method: SSERequestType.GET,
      url: url,
      header: headers,
    );
  }
}
