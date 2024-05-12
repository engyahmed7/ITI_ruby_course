require 'time'

module Logger
  def log_info(message)
    log("info", message)
  end

  def log_warning(message)
    log("warning", message)
  end

  def log_error(message)
    log("error", message)
  end

  private

  def log(log_type, message)
    timestamp = Time.now.iso8601
    File.open("app.log", "a") do |file|
      file.puts("#{timestamp} -- #{log_type} -- #{message}")
    end
  end
end

class User
  attr_reader :name
  attr_accessor :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end
end

class Transaction
  attr_reader :user, :value

  def initialize(user, value)
    @user = user
    @value = value
  end
end

class Bank
  def process_transactions(transactions, &callback)
    raise NotImplementedError, "This method is abstract and must be implemented in a subclass"
  end
end

class CBABank < Bank
  include Logger

  attr_reader :users

  def initialize(users)
    @users = users
  end

  def process_transactions(transactions, &callback)
    log_info("Processing Transactions #{transaction_summaries(transactions)}")

    transactions.each do |transaction|
      begin
        perform_transaction(transaction)
        callback.call("success")
      rescue StandardError => e
        log_error("Transaction failed: #{e.message}")
        callback.call("failure")
      end
    end
  end

  private

  def transaction_summaries(transactions)
    transactions.map { |t| "User #{t.user.name} transaction with value #{t.value}" }.join(', ')
  end

  def perform_transaction(transaction)
    user = transaction.user
    value = transaction.value

    raise "Not enough balance" if user.balance + value < 0
    raise "#{user.name} not found in the bank" unless users.include?(user)

    user.balance += value
    log_info("User #{user.name} transaction with value #{value} succeeded")
    log_warning("#{user.name} has 0 balance") if user.balance.zero?
  end
end

users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

outside_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(outside_bank_users[0], -100)
]

cbabank = CBABank.new(users)
cbabank.process_transactions(transactions) do |status|
  puts "Call endpoint for #{status == "success" ? "Success" : "Failure"}"
end
