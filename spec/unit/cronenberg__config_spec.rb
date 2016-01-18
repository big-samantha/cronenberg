require 'spec_helper'
require 'cronenberg/config'
require 'rspec/mocks/standalone'

describe Cronenberg::Config do
  context "#initialize" do
    let(:config_hash) do
      {
        host: 'vsphere.pizza.com',
        user: 'pizzamaster5000',
        password: 'pizzapass',
      }
    end

    let(:config_hash_partial) do
      {
        host: 'vsphere.pizza.com',
        user: 'pizzamaster5000',
      }
    end

    context "with no env variables or config file" do
      it "should raise a RunTime error" do
        expect{ Cronenberg::Config.new }.to raise_error(RuntimeError)
      end
    end

    context "with partial env vars or config file" do
      before do
        allow_any_instance_of(Cronenberg::Config).to receive(:process_environment_variables).and_return(config_hash_partial)
      end

      it "should raise a RunTime error listing missing config items" do
        expect { Cronenberg::Config.new }.to raise_error(RuntimeError, /missing settings/)
      end
    end

    context "with a valid configuration hash" do
      before do
        allow_any_instance_of(Cronenberg::Config).to receive(:process_environment_variables).and_return(config_hash)
      end
      it "returns valid config items" do
        config = Cronenberg::Config.new
        expect(config.host).to eq(config_hash[:host])
        expect(config.user).to eq(config_hash[:user])
        expect(config.password).to eq(config_hash[:password])
      end
    end
  end
end
