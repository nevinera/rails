require 'abstract_unit'

module MailerHelper
  def person_name
    "Mr. Joe Person"
  end
end

class HelperMailer < ActionMailer::Base
  helper MailerHelper
  helper :example

  def use_helper
    recipients 'test@localhost'
    subject    "using helpers"
    from       "tester@example.com"
  end

  def use_example_helper
    recipients 'test@localhost'
    subject    "using helpers"
    from       "tester@example.com"

    @text = "emphasize me!"
  end

  def use_mail_helper
    recipients 'test@localhost'
    subject    "using mailing helpers"
    from       "tester@example.com"

    @text = "But soft! What light through yonder window breaks? It is the east, " +
            "and Juliet is the sun. Arise, fair sun, and kill the envious moon, " +
            "which is sick and pale with grief that thou, her maid, art far more " +
            "fair than she. Be not her maid, for she is envious! Her vestal " +
            "livery is but sick and green, and none but fools do wear it. Cast " +
            "it off!"
  end

  def use_helper_method
    recipients 'test@localhost'
    subject    "using helpers"
    from       "tester@example.com"

    @text = "emphasize me!"
  end

  private

    def name_of_the_mailer_class
      self.class.name
    end
    helper_method :name_of_the_mailer_class
end

class MailerHelperTest < ActiveSupport::TestCase
  def new_mail( charset="utf-8" )
    mail = Mail.new
    mail.set_content_type "text", "plain", { "charset" => charset } if charset
    mail
  end

  def setup
    set_delivery_method :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries.clear
  end
  
  def teardown
    restore_delivery_method
  end
  
  def test_use_helper
    mail = HelperMailer.use_helper
    assert_match %r{Mr. Joe Person}, mail.encoded
  end

  def test_use_example_helper
    mail = HelperMailer.use_example_helper
    assert_match %r{<em><strong><small>emphasize me!}, mail.encoded
  end

  def test_use_helper_method
    mail = HelperMailer.use_helper_method
    assert_match %r{HelperMailer}, mail.encoded
  end

  def test_use_mail_helper
    mail = HelperMailer.use_mail_helper
    assert_match %r{  But soft!}, mail.encoded
    assert_match %r{east, and\r\n  Juliet}, mail.encoded
  end
end

