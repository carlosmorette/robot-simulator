defmodule RobotSimulator do
  defstruct position: {0, 0}, direction: :north

  @directions [:north, :east, :west, :south, nil]
  @invalid_direction {:error, "invalid direction"}
  @invalid_position {:error, "invalid position"}
  @invalid_instruction {:error, "invalid instruction"}
  @valid_instructions ["L", "R", "A"]

  @type t :: %__MODULE__{}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """

  defguard is_valid_position?(x, y) when is_integer(x) and is_integer(y)

  def create(), do: %__MODULE__{}

  def create(direction, _) when not (direction in @directions), do: @invalid_direction

  @spec create(direction :: atom, position :: {integer, integer}) :: RobotSimulator.t()
  def create(direction, {x, y}) when is_valid_position?(x, y) do
    %__MODULE__{
      direction: direction,
      position: {x, y}
    }
  end

  def create(_direction, _position), do: @invalid_position

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot :: any, instructions :: String.t()) :: any
  def simulate(robot, instructions) do
    instructions
    |> String.split("", trim: true)
    |> Enum.reduce_while(robot, fn i, r ->
      if i in @valid_instructions do
        {:cont, exec_instruction(r, i)}
      else
        {:halt, @invalid_instruction}
      end
    end)
  end

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.direction
  end

  @doc """
  Return the robot's position.
  """
  @spec position(robot :: any) :: {integer, integer}
  def position(robot) do
    robot.position
  end

  def exec_instruction(robot, "A"), do: %{robot | position: advance(robot)}
  def exec_instruction(robot, "L"), do: %{robot | direction: rotate(robot.direction, "L")}
  def exec_instruction(robot, "R"), do: %{robot | direction: rotate(robot.direction, "R")}

  def advance(robot) do
    [x, y] = Tuple.to_list(robot.position)

    case robot.direction do
      :east -> {x + 1, y}
      :west -> {x - 1, y}
      :south -> {x, y - 1}
      :north -> {x, y + 1}
    end
  end

  def rotate(:north, direction) do
    case direction do
      "L" -> :west
      "R" -> :east
    end
  end

  def rotate(:east, direction) do
    case direction do
      "L" -> :north
      "R" -> :south
    end
  end

  def rotate(:south, direction) do
    case direction do
      "L" -> :east
      "R" -> :west
    end
  end

  def rotate(:west, direction) do
    case direction do
      "L" -> :south
      "R" -> :north
    end
  end
end
