class Transaction < ApplicationRecord
  belongs_to :user, class_name: 'User'
  enum status: { pending: 0, completed: 1, failed: 2 }
  enum kind: { deposit: 0, withdraw: 1 }

  def self.deposit(user, amount, currency)
    charge = CoinbaseCommerce::Charge.create(
      name: "Deposit to account",
      description: "Deposit to user account",
      local_price: {
        amount: amount,
        currency: currency
      },
      pricing_kind: "fixed_price",
      metadata: {
        user_id: user.id
      }
    )
    Transaction.create!(
      user: user,
      charge_id: charge.id,
      amount: amount,
      currency: currency,
      status: :pending,
      kind: :deposit
    )
  end

  def self.withdraw(user, amount, currency)
    withdrawal = CoinbaseCommerce::Payout.create(
      amount: {
        amount: amount,
        currency: currency
      },
      metadata: {
        user_id: user.id
      }
    )
    Transaction.create!(
      user: user,
      charge_id: withdrawal.id,
      amount: amount,
      currency: currency,
      status: :pending,
      kind: :withdraw
    )
  end

  def complete!
    self.update(status: :completed)
  end

  def fail!
    self.update(status: :failed)
  end
end
