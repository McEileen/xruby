class WordProblem
  attr_reader :question
  def initialize(question)
    @question = question
  end

  def answer
    if too_complicated?
      fail ArgumentError.new("I don't understand the question")
    end

    unless @answer
      @answer = n1.send(operation(2), n2)
      @answer = @answer.send(operation(5), n3) if chain?
    end

    @answer
  end

  private

  def too_complicated?
    matches.nil?
  end

  def matches
    @matches ||= question.match(pattern)
  end

  def pattern
    operations = '(plus|minus|multiplied by|divided by)'
    /What is (-?\d+) #{operations} (-?\d+)( #{operations} (-?\d+))?\?/
  end

  def operation(index)
    case matches[index]
    when 'plus' then :+
    when 'minus' then :-
    when 'multiplied by' then :*
    when 'divided by' then :/
    end
  end

  def n1
    matches[1].to_i
  end

  def n2
    matches[3].to_i
  end

  def n3
    matches[6].to_i
  end

  def chain?
    !!matches[4]
  end
end
