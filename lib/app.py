import sys
import io
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/execute', methods=['POST'])
def execute_code():
    try:
        # Get the code from the request
        data = request.json
        user_code = data.get("code", "")

        # Create a StringIO object to capture the output
        output_buffer = io.StringIO()
        sys.stdout = output_buffer  # Redirect stdout to the buffer

        # Define a global and local context for code execution
        global_context = {}
        local_context = {}

        # Execute the code
        exec(user_code, global_context, local_context)

        # Restore original stdout
        sys.stdout = sys.__stdout__

        # Fetch the captured output
        output = output_buffer.getvalue()
        output_buffer.close()

        return jsonify({"status": "success", "output": output})
    except Exception as e:
        sys.stdout = sys.__stdout__  # Restore stdout in case of an exception
        return jsonify({"status": "error", "message": str(e)})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
