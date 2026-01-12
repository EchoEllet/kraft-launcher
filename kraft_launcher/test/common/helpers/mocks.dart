import 'package:kraft_launcher/account/data/microsoft_auth_api/microsoft_auth_api.dart';
import 'package:mocktail/mocktail.dart';

// TODO: Prefer fakes over mocks. MicrosoftAuthApi will be replaced: https://github.com/KraftLauncher/kraft-launcher/issues/8

class MockMicrosoftAuthApi extends Mock implements MicrosoftAuthApi {}
