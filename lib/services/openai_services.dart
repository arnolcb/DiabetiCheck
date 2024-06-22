import 'dart:convert';
import 'package:http/http.dart' as http;

String apiKey = "";

Future<Map<String, dynamic>> sendTextCompletionRequest(String message) async {
  String baseUrl = "https://api.openai.com/v1/chat/completions";
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8",
    "Authorization": "Bearer $apiKey"
  };

  // Q&A
  List<Map<String, String>> examples = [
    {"role": "system", "content": "Eres un asesor sobre diabetes. Proporciona respuestas claras y precisas a las preguntas relacionadas con la diabetes."},
    {"role": "user", "content": "¿Qué es la diabetes?"},
    {"role": "assistant", "content": "La diabetes es una enfermedad que ocurre cuando el organismo es incapaz de generar insulina o utilizarla correctamente. El páncreas produce la insulina para regular el uso de la glucosa (azúcar) en el organismo."},
    {"role": "user", "content": "¿Existen factores de riesgo de diabetes?"},
    {"role": "assistant", "content": "Sí. Algunos factores de riesgo son: antecedentes de familiares que padezcan o hayan padecido diabetes mellitus, sobrepeso y obesidad; enfermedad cardiovascular; grasas alteradas en sangre (dislipidemia); quistes en los ovarios; mujeres que hayan tenido bebés con un peso mayor a 4 kilos y pacientes que, por enfermedad, tengan que usar tratamiento con esteroides o que tengan tratamiento de esquizofrenia."},
    // Pendiente agregar más
  ];

  // Question to user
  examples.add({"role": "user", "content": message});

  try {
    var res = await http.post(Uri.parse(baseUrl),
        headers: headers,
        body: utf8.encode(json.encode({
          "model": "gpt-3.5-turbo",
          "messages": examples,
          "max_tokens": 200,
          "temperature": 0.7,
        })));
    if (res.statusCode == 200) {
      return jsonDecode(utf8.decode(res.bodyBytes));
    } else {
      return {"error": "Error: ${res.statusCode}, ${res.reasonPhrase}"};
    }
  } catch (e) {
    return {"error": "Request failed: $e"};
  }
}
