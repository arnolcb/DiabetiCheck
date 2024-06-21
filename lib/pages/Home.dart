import 'package:flutter/material.dart';
import 'package:contentcreator/services/openai_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> messages = [];
  TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  void _sendMessage() async {
    String inputMessage = _controller.text.trim();
    if (inputMessage.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "content": inputMessage});
      _controller.clear();
      _isLoading = true;
    });

    var res = await sendTextCompletionRequest(inputMessage);
    String responseMessage;

    if (res.containsKey("choices")) {
      responseMessage = res["choices"][0]["message"]["content"];
    } else if (res.containsKey("error")) {
      responseMessage = res["error"];
    } else {
      responseMessage = "Unexpected error occurred.";
    }

    setState(() {
      messages.add({"role": "assistant", "content": responseMessage});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF343540),
      appBar: AppBar(
        backgroundColor: Color(0xFF212023),
        centerTitle: true,
        title: Text("Asesor de Diabetes"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                bool isUserMessage = message["role"] == "user";

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    mainAxisAlignment:
                        isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isUserMessage ? Colors.blueAccent : Colors.grey[700],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          message["content"] ?? "",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_isLoading) CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(106, 158, 158, 158),
                      hintText: "Escribe tu pregunta...",
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
