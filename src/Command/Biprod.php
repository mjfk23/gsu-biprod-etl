<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command;

use Gadget\Console\Command\ShellCommand;
use Gadget\Console\Shell\ProcessShell;
use Gadget\Console\Shell\ProcessShellArgs;
use Gadget\Console\Shell\ProcessShellEnv;
use Gadget\Console\Shell\ProcessShellOutput;
use Gsu\Biprod\Factory\ShellCommandFactory;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

abstract class Biprod extends ShellCommand
{
    /**
     * @param ShellCommandFactory $shellCommandFactory
     */
    public function __construct(protected ShellCommandFactory $shellCommandFactory)
    {
        parent::__construct();
    }


    /** @inheritdoc */
    protected function getEnv(
        InputInterface $input,
        OutputInterface $output
    ): ProcessShellEnv {
        return new ProcessShellEnv(
            array_filter([
                'ORACLE_HOME' => $_ENV['ORACLE_HOME'] ?? $_SERVER['ORACLE_HOME'] ?? null,
                'TNS_ADMIN' => $_ENV['TNS_ADMIN'] ?? $_SERVER['TNS_ADMIN'] ?? null,
            ]),
            dirname(__DIR__, 2)
        );
    }


    /**
     * @param InputInterface $input
     * @param OutputInterface $output
     * @return ProcessShellOutput
     */
    protected function getOutput(
        InputInterface $input,
        OutputInterface $output
    ): ProcessShellOutput {
        return $this->output ?? new ProcessShellOutput(function (string $type, string $message) use ($output): void {
            $message = trim($message);
            $this->info($message);
            if ($type === ProcessShell::START || $type === ProcessShell::TERMINATE) {
                $output->writeln($message);
            }
        });
    }
}
