class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_user!, :set_transaction, only: %i[show destroy]

  def index
    @transactions = current_user.transactions
    render json: @transactions
  end

  def create
    @transaction.user = current_user
    @transaction = Transaction.new(transaction_params)
    if @transaction.kind == 0
      @transaction = Transaction.deposit(current_user, params[:amount], params[:currency])
      if @transaction.persisted?
        render json: @transaction
      else
        render json: { errors: @transaction.errors }, status: :unprocessable_entity
      end
    elsif @transaction.kind == 1
      @transaction = Transaction.withdraw(current_user, params[:amount], params[:currency])
      if @transaction.persisted?
        render json: @transaction
      else
        render json: { errors: @transaction.errors }, status: :unprocessable_entity
      end
    end
  end

  def show
    render json: @transaction
  end

  def destroy
    @transaction.destroy
  end

  private

  def set_transaction
    @transaction = current_user.transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:kind, :amount, :currency)
  end
end
