class Api::ZipCodeController < ApplicationController
  def show
    if params[:zip_code].blank?
      render json: { error: "CEP não informado" }, status: :bad_request
      return
    end

    zip_code = ZipCode.new(params[:zip_code])

    if zip_code.city.present?
      render json: {
        street: zip_code.address_street,
        city: zip_code.address_city,
        state: zip_code.address_state
      }
    else
      render json: { error: "CEP inválido ou não encontrado" }, status: :not_found
    end
  end
end
