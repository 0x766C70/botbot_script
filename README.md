# botbot_script

A Bash script that sends messages to [Mistral AI](https://mistral.ai/) agents via their Conversations API, with support for multi-turn conversations.

## Requirements

- `bash` (≥ 4)
- [`curl`](https://curl.se/)
- [`jq`](https://stedolan.github.io/jq/)
- A valid [Mistral AI API key](https://console.mistral.ai/)

## Usage

```bash
./agent2.2.sh <speaker> <brain> <message> [conversation_id]
```

### Arguments

| Argument          | Required | Description                                                                 |
|-------------------|----------|-----------------------------------------------------------------------------|
| `speaker`         | Yes      | Name of the person sending the message (e.g. `alice`)                      |
| `brain`           | Yes      | Agent to use. One of: `botbot_fdn`, `botbot_mifa`                          |
| `message`         | Yes      | The message to send to the agent                                            |
| `conversation_id` | No       | Existing conversation ID to continue a previous conversation                |

### Output

The script outputs a JSON object with the following fields:

```json
{
  "message": "<agent reply>",
  "conv": "<conversation_id>"
}
```

Pass the returned `conv` value as the fourth argument to continue the same conversation on subsequent calls.

## Examples

**Start a new conversation:**

```bash
./agent2.2.sh alice botbot_fdn "Hello, how are you?"
```

**Continue an existing conversation:**

```bash
./agent2.2.sh alice botbot_fdn "Tell me more." "conv_abc123"
```

## Configuration

The `MISTRAL_API_KEY` variable at the top of the script must be set to your Mistral AI API key. For production use, consider loading it from an environment variable instead of hardcoding it:

```bash
MISTRAL_API_KEY="${MISTRAL_API_KEY:?MISTRAL_API_KEY is not set}"
```

## License

This project is maintained by [0x766C70](https://github.com/0x766C70).
