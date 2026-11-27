
MODEL=google/gemini-flash-lite-latest
echo $MODEL
WORK_DIR=$(pwd)
echo $WORK_DIR
INSTRUCTIONS_FILE="$WORK_DIR/TODO_INT.md"
INSTRUCTIONS="Read and execute instructions in $INSTRUCTIONS_FILE"
echo $INSTRUCTIONS_FILE
echo $INSTRUCTIONS
npx opencode run \
    --model "$MODEL" \
    --auto \
    "$INSTRUCTIONS"
cat COMMIT_MESSAGE.md