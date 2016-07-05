class BatchesController < ApplicationController
  def create
    selected_items_uuids = batch_parameters.fetch(:items,{}).select {|k,v| v=='1' }.keys
    selected_items = Item.where(uuid:selected_items_uuids)
    @batch = Batch.new(items:selected_items,user_swipecard:batch_parameters[:user_swipecard])
    if @batch.save
      redirect_to @batch, notice: t('.success')
    else
      redirect_back fallback_location: :root , alert: t('.failure',errors: @batch.errors.full_messages.to_sentence)
    end
  end

  def show
    @batch = Batch.find(params[:id])
  end

  def destroy
    @batch = Batch.find(params[:id])
    # Its unlikely we'll end up with an inboxless batch, but not entirely impossible
    # Here is not the place to kick up a fuss
    redirect_target = @batch.inboxes.first||:root
    if @batch.destroy
      redirect_to redirect_target, notice: t('.success')
    else
      redirect_to @batch, alert: t('.failure',errors: @batch.errors.full_messages.to_sentence)
    end
  end

  def batch_parameters
    params.require(:batch)
  end
end
