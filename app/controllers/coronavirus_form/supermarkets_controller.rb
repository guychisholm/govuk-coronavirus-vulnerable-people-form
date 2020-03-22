# frozen_string_literal: true

class CoronavirusForm::SupermarketsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include FieldValidationHelper

  def show
    render "coronavirus_form/#{PAGE}"
  end

  def submit
    supermarkets = sanitize(params[:supermarkets]).presence
    session[:supermarkets] = supermarkets

    invalid_fields = validate_radio_field(
      PAGE,
      radio: supermarkets,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      log_validation_error(invalid_fields)
      render "coronavirus_form/#{PAGE}", status: :unprocessable_entity
    elsif session["check_answers_seen"]
      redirect_to controller: "coronavirus_form/check_answers", action: "show"
    else
      redirect_to controller: "coronavirus_form/#{NEXT_PAGE}", action: "show"
    end
  end

private

  PAGE = "supermarkets"
  NEXT_PAGE = "basic_care_needs"

  def previous_path
    coronavirus_form_essential_supplies_path
  end
end