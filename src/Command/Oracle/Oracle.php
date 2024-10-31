<?php

declare(strict_types=1);

namespace Gsu\Biprod\Command\Oracle;

use Gadget\Console\Command\ShellCommand;
use Gadget\Console\Shell\ProcessShell;
use Gadget\Console\Shell\ProcessShellOutput;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

abstract class Oracle extends ShellCommand
{
    /** @inheritdoc */
    protected function configure(): void
    {
        $this->addOption(
            'database',
            'db',
            InputOption::VALUE_REQUIRED,
            'Database descriptor',
            $this->getShellEnv()->getEnv()['APP_DATABASE'] ?? null
        );
    }


    /**
     * @param OutputInterface $output
     * @return ProcessShellOutput
     */
    protected function getShellOutput(OutputInterface $output): ProcessShellOutput
    {
        return new ProcessShellOutput(function (string $type, string $message): void {
            if ($type === ProcessShell::ERR) {
                $this->error($message);
            } else {
                $this->info($message);
            }
        });
    }
}
